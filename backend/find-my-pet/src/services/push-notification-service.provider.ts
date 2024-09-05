// src/services/push-notification-service.provider.ts
import { Provider } from '@loopback/core';
import { PushNotificationService } from './push-notification.service';

export class PushNotificationServiceProvider implements Provider<PushNotificationService> {
  value(): PushNotificationService {
    return new PushNotificationService();
  }
}
