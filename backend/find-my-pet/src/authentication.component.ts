// Copyright IBM Corp. and LoopBack contributors 2018,2020. All Rights Reserved.
// Node module: @loopback/authentication
// This file is licensed under the MIT License.
// License text available at https://opensource.org/licenses/MIT


import {Component, ContextTags, injectable} from '@loopback/core';
import {AuthenticationBindings} from './keys';
import {AuthenticateActionProvider, AuthenticationMiddlewareProvider} from './providers-provider/auth-action.provider-provider';
import {AuthMetadataProvider} from './providers-provider/auth-metadata.provider-provider';
import {AuthenticationStrategyProvider} from './providers-provider/auth-strategy.provider-provider';

@injectable({tags: {[ContextTags.KEY]: AuthenticationBindings.COMPONENT}})
export class AuthenticationComponent implements Component {
  providers = {
    [AuthenticationBindings.AUTH_ACTION.key]: AuthenticateActionProvider,
    [AuthenticationBindings.STRATEGY.key]: AuthenticationStrategyProvider,
    [AuthenticationBindings.METADATA.key]: AuthMetadataProvider,
    [AuthenticationBindings.AUTHENTICATION_MIDDLEWARE.key]:
      AuthenticationMiddlewareProvider,
  };
}
