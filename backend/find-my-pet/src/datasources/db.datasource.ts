import {inject, lifeCycleObserver, LifeCycleObserver} from '@loopback/core';
import {juggler} from '@loopback/repository';

const config = {
  name: 'db',
  connector: 'postgresql',
  // url: 'postgres://findmypet_user:k62bfh2f3g44ugxX8lZjEFJeaUHqycA0@dpg-cl54psal7jac73cc74mg-a.frankfurt-postgres.render.com/findmypet?ssl=true',
  url: 'postgres://find_my_pet2_user:v4a8q9MkSVytgdAslWhRxLPM4qVw9c4e@dpg-cn9h6a6n7f5s73fn01s0-a.frankfurt-postgres.render.com/find_my_pet2?ssl=true',
  //url: 'postgres://postgres:password@localhost:5432',
  host: '',
  port: null,
  user: '',
  password: '',
  database: ''

};

// Observe application's life cycle to disconnect the datasource when
// application is stopped. This allows the application to be shut down
// gracefully. The `stop()` method is inherited from `juggler.DataSource`.
// Learn more at https://loopback.io/doc/en/lb4/Life-cycle.html
@lifeCycleObserver('datasource')
export class DbDataSource extends juggler.DataSource
  implements LifeCycleObserver {
  static dataSourceName = 'db';
  static readonly defaultConfig = config;

  constructor(
    @inject('datasources.config.db', {optional: true})
    dsConfig: object = config,
  ) {
    super(dsConfig);
  }
}
