import {model, property, repository} from '@loopback/repository';

import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  Where
} from '@loopback/repository';
import {
  del, get,
  getModelSchemaRef, HttpErrors, param, patch, post, put, requestBody,
  response,
  SchemaObject
} from '@loopback/rest';

import {inject} from '@loopback/core';
import {genSalt, hash} from 'bcryptjs';
import {authenticate} from '../decorators';
import {validateEmail} from '../email-validator';
import {SecurityBindings, TokenServiceBindings, UserServiceBindings} from '../keys';
import {User} from '../models';
import {validatePassword} from '../password-validator';
import {UserRepository} from '../repositories';
import {Credentials, MyUserService, TokenService} from '../services';
import {securityId, UserProfile} from '../types';
// Import PushNotificationService
import { PushNotificationService } from '../services/push-notification.service';


@model()
export class NewUserRequest extends User {
  @property({
    type: 'string',
    required: true,
  })
  password: string;
}

const CredentialsSchema: SchemaObject = {
  type: 'object',
  required: ['email', 'password'],
  properties: {
    email: {
      type: 'string',
      format: 'email',
    },
    password: {
      type: 'string',
      minLength: 8,
    },
  },
};

export const CredentialsRequestBody = {
  description: 'The input of login function',
  required: true,
  content: {
    'application/json': {schema: CredentialsSchema},
  },
};


@authenticate('jwt') // <---- Apply the @authenticate decorator at the class level
export class UserController {
  constructor(
    @inject(TokenServiceBindings.TOKEN_SERVICE)
    public jwtService: TokenService,
    @inject(UserServiceBindings.USER_SERVICE)
    public userService: MyUserService,
    @inject(SecurityBindings.USER, {optional: true})
    public user: UserProfile,
    @repository(UserRepository) protected userRepository: UserRepository,
    // Inject the PushNotificationService
    @inject('services.PushNotificationService')
    private pushNotificationService: PushNotificationService,
  ) { }

  @post('/users')
  @response(200, {
    description: 'User model instance',
    content: {'application/json': {schema: getModelSchemaRef(User)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(User, {
            title: 'NewUser',
            exclude: ['id'],
          }),
        },
      },
    })
    user: Omit<User, 'id'>,
  ): Promise<User> {
    return this.userRepository.create(user);
  }

@authenticate.skip()
  @get('/users/count')
  @response(200, {
    description: 'User model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(User) where?: Where<User>,
  ): Promise<Count> {
    return this.userRepository.count(where);
  }

  @get('/users')
  @response(200, {
    description: 'Array of User model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(User, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(User) filter?: Filter<User>,
  ): Promise<User[]> {
    return this.userRepository.find(filter);
  }

  @patch('/users')
  @response(200, {
    description: 'User PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(User, {partial: true}),
        },
      },
    })
    user: User,
    @param.where(User) where?: Where<User>,
  ): Promise<Count> {
    return this.userRepository.updateAll(user, where);
  }

  @get('/users/{id}')
  @response(200, {
    description: 'User model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(User, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(User, {exclude: 'where'}) filter?: FilterExcludingWhere<User>
  ): Promise<User> {
    return this.userRepository.findById(id, filter);
  }

  @patch('/users/{id}')
  @response(204, {
    description: 'User PATCH success',
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(User, {partial: true}),
        },
      },
    })
    user: User,
  ): Promise<void> {
    await this.userRepository.updateById(id, user);
  }

  @put('/users/{id}')
  @response(204, {
    description: 'User PUT success',
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() user: User,
  ): Promise<void> {
    await this.userRepository.replaceById(id, user);
  }

  @del('/users/{id}')
  @response(204, {
    description: 'User DELETE success',
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.userRepository.deleteById(id);

  }

  // DEVICE TOKEN
  @authenticate.skip()
  @patch('/users/{id}/device-token')
  @response(204, {
    description: 'Device token updated successfully',
  })
  async updateDeviceToken(
    @param.path.number('id') userId: number,
    @requestBody({
      content: {
        'application/json': {
          schema: {
            type: 'object',
            properties: {
              deviceToken: { type: 'string' },
            },
          },
        },
      },
    })
    deviceTokenData: { deviceToken: string },
  ): Promise<void> {
    // Verify that the userId corresponds to an existing user
    const userExists = await this.userRepository.exists(userId);
    if (!userExists) {
      throw new HttpErrors.NotFound(`User ID ${userId} not found`);
    }

    // Update the user's device token in the database
    await this.userRepository.updateById(userId, { deviceToken: deviceTokenData.deviceToken });

    // After updating the device token, send a notification
  if (deviceTokenData.deviceToken) {
    try {
      await this.pushNotificationService.sendNotification(
        deviceTokenData.deviceToken,
        "Welcome!"
      );
    } catch (error) {
      console.error('Error sending push notification:', error);
    }
  }
  }
  //END DEVICE TOKEN

  @authenticate.skip()
  @post('/users/login', {
    responses: {
      '200': {
        description: 'Token',
        content: {
          'application/json': {
            schema: {
              type: 'object',
              properties: {
                token: {
                  type: 'string',
                },
              },
            },
          },
        },
      },
    },
  })
  async login(
    @requestBody(CredentialsRequestBody) credentials: Credentials,
  ): Promise<{token: string}> {
    // ensure the user exists, and the password is correct
    const user = await this.userService.verifyCredentials(credentials);
    // convert a User object into a UserProfile object (reduced set of properties)
    const userProfile = this.userService.convertToUserProfile(user);

    // create a JSON Web Token based on the user profile
    const token = await this.jwtService.generateToken(userProfile);
    return {token};
  }

  @authenticate('jwt')
  @get('/whoAmI', {
    responses: {
      '200': {
        description: 'Return current user',
        content: {
          'application/json': {
            schema: {
              type: 'object',
              properties: {
                id: {type: 'string'},
                firstname: {type: 'string'},
                lastname: {type: 'string'},
                email: {type: 'string'},
                phoneNumber: {type: 'string'},
                // Add other properties as needed
              },
            },
          },
        },
      },
    },
  })
  async whoAmI(
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<UserProfile> {
    const userId = currentUserProfile[securityId];
    const userData = await this.userService.findUserById(userId)
    const userProfile = this.userService.convertToUserProfile(userData);
    return userProfile;
  }

  @authenticate.skip()
  @post('/signup', {
    responses: {
      '200': {
        description: 'User',
        content: {
          'application/json': {
            schema: {
              'x-ts-type': User,
            },
          },
        },
      },
    },
  })
  async signUp(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(NewUserRequest, {
            title: 'NewUser',
          }),
        },
      },
    })
    newUserRequest: NewUserRequest,
  ): Promise<User> {

    // Überprüfen Sie die Gültigkeit der E-Mail-Adresse
    if (!validateEmail(newUserRequest.email)) {
      throw new HttpErrors.BadRequest('E-Mail does not match the format!');
    }

    // Überprüfen Sie die Gültigkeit des Passworts
    if (!validatePassword(newUserRequest.password)) {
      throw new HttpErrors.BadRequest('Invalid password. It must be at least 8 characters long and contain at least one uppercase letter, one special character, and one number.');
    }

    // Überprüfe, ob die E-Mail bereits vorhanden ist
    const existingUser = await this.userRepository.findOne({
      where: {email: newUserRequest.email},
    });

    if (existingUser) {
      // Die E-Mail existiert bereits, wirf eine eigene Exception
      throw new HttpErrors.BadRequest('E-Mail is already used');
    }


    const password = await hash(newUserRequest.password, await genSalt());
    const savedUser = await this.userRepository.create({
      ...newUserRequest,
      password, // Include the hashed password
    });

    await this.userRepository.userCredentials(savedUser.id).create({password: password, email: newUserRequest.email});

    return savedUser;
  }


}
