import {
  Count,
  CountSchema,
  Filter,
  repository,
  Where,
} from '@loopback/repository';
import {
  del,
  get,
  getModelSchemaRef,
  getWhereSchemaFor,
  param,
  patch,
  post,
  requestBody,
} from '@loopback/rest';
import {
  User,
  PetReport,
} from '../models';
import {UserRepository} from '../repositories';

export class UserPetReportController {
  constructor(
    @repository(UserRepository) protected userRepository: UserRepository,
  ) { }

  @get('/users/{id}/pet-reports', {
    responses: {
      '200': {
        description: 'Array of User has many PetReport',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(PetReport)},
          },
        },
      },
    },
  })
  async find(
    @param.path.number('id') id: number,
    @param.query.object('filter') filter?: Filter<PetReport>,
  ): Promise<PetReport[]> {
    return this.userRepository.petReports(id).find(filter);
  }

  @post('/users/{id}/pet-reports', {
    responses: {
      '200': {
        description: 'User model instance',
        content: {'application/json': {schema: getModelSchemaRef(PetReport)}},
      },
    },
  })
  async create(
    @param.path.number('id') id: typeof User.prototype.id,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PetReport, {
            title: 'NewPetReportInUser',
            exclude: ['id'],
            optional: ['userId']
          }),
        },
      },
    }) petReport: Omit<PetReport, 'id'>,
  ): Promise<PetReport> {
    return this.userRepository.petReports(id).create(petReport);
  }

  @patch('/users/{id}/pet-reports', {
    responses: {
      '200': {
        description: 'User.PetReport PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PetReport, {partial: true}),
        },
      },
    })
    petReport: Partial<PetReport>,
    @param.query.object('where', getWhereSchemaFor(PetReport)) where?: Where<PetReport>,
  ): Promise<Count> {
    return this.userRepository.petReports(id).patch(petReport, where);
  }

  @del('/users/{id}/pet-reports', {
    responses: {
      '200': {
        description: 'User.PetReport DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.number('id') id: number,
    @param.query.object('where', getWhereSchemaFor(PetReport)) where?: Where<PetReport>,
  ): Promise<Count> {
    return this.userRepository.petReports(id).delete(where);
  }
}
