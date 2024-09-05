import {inject} from '@loopback/core';
import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where
} from '@loopback/repository';
import {
  del, get,
  getModelSchemaRef, param, patch, post, put, requestBody,
  response
} from '@loopback/rest';
import {authenticate} from '../decorators';
import {PetReport} from '../models';
import {PetReportRepository, UserRepository} from '../repositories';
import {PushNotificationService} from '../services';

@authenticate('jwt')
export class PetReportController {
  constructor(
    @repository(PetReportRepository)
    public petReportRepository : PetReportRepository,
    @repository(UserRepository)
    public userRepository: UserRepository,
    @inject('services.PushNotificationService')
    private pushNotificationService: PushNotificationService,
  ) {}


  @post('/pet-reports')
  @response(200, {
    description: 'PetReport model instance',
    content: {'application/json': {schema: getModelSchemaRef(PetReport)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PetReport, {
            title: 'NewPetReport',
            exclude: ['id'],
          }),
        },
      },
    })
    petReport: Omit<PetReport, 'id'>,
  ): Promise<PetReport> {
    console.log("Creating pet report...");
    const createdReport = await this.petReportRepository.create(petReport);
    console.log("Pet report created:", createdReport);

  try {
    const user = await this.userRepository.findById(createdReport.userId);
    const deviceToken = user?.deviceToken;

    if (deviceToken) {
      console.log("Device token found, sending notification...");
      await this.pushNotificationService.sendNotification(deviceToken, "Your pet report has been successfully submitted.");
      console.log("Notification sent successfully to:", deviceToken);
    } else {
      console.error("Device token is undefined or empty for user with ID:", createdReport.userId);
    }
  } catch (error) {
    console.error("Error fetching user or sending notification:", error);
  }


  return createdReport;
}


  @authenticate.skip()
  @get('/pet-reports/count')
  @response(200, {
    description: 'PetReport model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(PetReport) where?: Where<PetReport>,
  ): Promise<Count> {
    return this.petReportRepository.count(where);
  }

  @authenticate.skip()
  @get('/pet-reports')
  @response(200, {
    description: 'Array of PetReport model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(PetReport, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(PetReport) filter?: Filter<PetReport>,
  ): Promise<PetReport[]> {
    return this.petReportRepository.find(filter);
  }

  @patch('/pet-reports')
  @response(200, {
    description: 'PetReport PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PetReport, {partial: true}),
        },
      },
    })
    petReport: PetReport,
    @param.where(PetReport) where?: Where<PetReport>,
  ): Promise<Count> {
    return this.petReportRepository.updateAll(petReport, where);
  }


  @get('/pet-reports/{id}')
  @response(200, {
    description: 'PetReport model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(PetReport, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(PetReport, {exclude: 'where'}) filter?: FilterExcludingWhere<PetReport>
  ): Promise<PetReport> {
    return this.petReportRepository.findById(id, filter);
  }
  @patch('/pet-reports/{id}')
  @response(204, {
    description: 'PetReport PATCH success',
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PetReport, {partial: true}),
        },
      },
    })
    petReport: PetReport,
  ): Promise<void> {
    await this.petReportRepository.updateById(id, petReport);
  }

  @authenticate.skip()
  @put('/pet-reports/{id}')
  @response(204, {
    description: 'PetReport PUT success',
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() petReport: PetReport,
  ): Promise<void> {
    await this.petReportRepository.replaceById(id, petReport);
  }

  @del('/pet-reports/{id}')
  @response(204, {
    description: 'PetReport DELETE success',
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.petReportRepository.deleteById(id);
  }
}
