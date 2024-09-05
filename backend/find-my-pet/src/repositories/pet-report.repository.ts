import {Getter, inject} from '@loopback/core';
import {BelongsToAccessor, DefaultCrudRepository, repository} from '@loopback/repository';
import {DbDataSource} from '../datasources';
import {PetReport, PetReportRelations, User} from '../models';
import {UserRepository} from './user.repository';


export class PetReportRepository extends DefaultCrudRepository<
  PetReport,
  typeof PetReport.prototype.id,
  PetReportRelations
> {

  public readonly user: BelongsToAccessor<User, typeof PetReport.prototype.id>;


  constructor(
    @inject('datasources.db') dataSource: DbDataSource, @repository.getter('UserRepository') protected userRepositoryGetter: Getter<UserRepository>,
  ) {
    super(PetReport, dataSource);
    this.user = this.createBelongsToAccessorFor('user', userRepositoryGetter,);
    this.registerInclusionResolver('user', this.user.inclusionResolver);
  }
}
