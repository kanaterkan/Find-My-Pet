import {Getter, inject} from '@loopback/core';
import {DefaultCrudRepository, repository} from '@loopback/repository';
import {DbDataSource} from '../datasources';
import {UserCredentials, UserCredentialsRelations} from '../models';
import {UserRepository} from './user.repository';

export class UserCredentialsRepository extends DefaultCrudRepository<
  UserCredentials,
  typeof UserCredentials.prototype.email,
  UserCredentialsRelations
> {


  constructor(
    @inject('datasources.db') dataSource: DbDataSource,
    @repository.getter('UserRepository') protected userRepositoryGetter: Getter<UserRepository>,
    //@inject(UserServiceBindings.USER_REPOSITORY) protected userRepositoryGetter: Getter<UserRepository>,
  ) {
    super(UserCredentials, dataSource);
    //this.user = this.createHasOneRepositoryFactoryFor('user', userRepositoryGetter);
    // this.registerInclusionResolver('user', this.user.inclusionResolver);
  }
}
