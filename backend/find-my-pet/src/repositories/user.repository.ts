import {Getter, inject} from '@loopback/core';
import {DefaultCrudRepository, HasManyRepositoryFactory, HasOneRepositoryFactory, repository} from '@loopback/repository';
import {DbDataSource} from '../datasources';
import {PetReport, User, UserCredentials, UserRelations} from '../models';
import {PetReportRepository} from './pet-report.repository';
import {UserCredentialsRepository} from './user-credentials.repository';

export class UserRepository extends DefaultCrudRepository<
  User,
  typeof User.prototype.id,
  UserRelations
> {

  public readonly userCredentials: HasOneRepositoryFactory<UserCredentials, typeof User.prototype.id>;

  public readonly petReports: HasManyRepositoryFactory<PetReport, typeof User.prototype.id>;

  constructor(
    @inject('datasources.db') dataSource: DbDataSource,
    @repository.getter('UserCredentialsRepository') protected userCredentialsRepositoryGetter: Getter<UserCredentialsRepository>, @repository.getter('PetReportRepository') protected petReportRepositoryGetter: Getter<PetReportRepository>,
    //@inject(UserServiceBindings.USER_REPOSITORY) protected userRepositoryGetter: Getter<UserRepository>,
  ) {
    super(User, dataSource);
    this.petReports = this.createHasManyRepositoryFactoryFor('petReports', petReportRepositoryGetter,);
    this.registerInclusionResolver('petReports', this.petReports.inclusionResolver);
    this.userCredentials = this.createHasOneRepositoryFactoryFor('userCredentials', userCredentialsRepositoryGetter);
    this.registerInclusionResolver('userCredentials', this.userCredentials.inclusionResolver);
  }

  async findCredentials(
    userId: typeof User.prototype.id,
  ): Promise<UserCredentials | undefined> {
    return this.userCredentials(userId)
      .get()
      .catch(err => {
        if (err.code === 'ENTITY_NOT_FOUND') return undefined;
        throw err;
      });
  }
}


