import {
  repository,
} from '@loopback/repository';
import {
  param,
  get,
  getModelSchemaRef,
} from '@loopback/rest';
import {
  PetReport,
  User,
} from '../models';
import {PetReportRepository} from '../repositories';

export class PetReportUserController {
  constructor(
    @repository(PetReportRepository)
    public petReportRepository: PetReportRepository,
  ) { }

  @get('/pet-reports/{id}/user', {
    responses: {
      '200': {
        description: 'User belonging to PetReport',
        content: {
          'application/json': {
            schema: getModelSchemaRef(User),
          },
        },
      },
    },
  })
  async getUser(
    @param.path.number('id') id: typeof PetReport.prototype.id,
  ): Promise<User> {
    return this.petReportRepository.user(id);
  }
}
