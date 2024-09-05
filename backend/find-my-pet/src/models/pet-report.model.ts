import {belongsTo, Entity, model, property} from '@loopback/repository';
import {User} from './user.model';

@model()
export class PetReport extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @property({
    type: 'string',
    required: true,
  })
  petName: string;

  @property({
    type: 'string',
    required: true,
  })
  petType: string;

  @property({
    type: 'string',
    required: true,
  })
  petBreed: string;

  @property({
    type: 'string',
    required: true,
  })
  petDescription: string;

  @property({
    type: 'boolean',
    required: true,
  })
  petGender: boolean;

  @property({
    type: 'number',
    required: true,
  })
  dateReported: number;

  @property({
    type: 'string',
    required: true,
  })
  petPicture: string;

  @property({
    type: 'boolean',
    required: true,
  })
  isFound: boolean;

  @property({
    type: 'string',
    required: true,
  })
  location: string


  @belongsTo(() => User)
  userId: number;


  constructor(data?: Partial<PetReport>) {
    super(data);
  }
}

export interface PetReportRelations {
  // describe navigational properties here
}

export type PetReportWithRelations = PetReport & PetReportRelations;
