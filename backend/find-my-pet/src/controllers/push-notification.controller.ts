// src/controllers/push-notification.controller.ts

import {inject} from '@loopback/core';
import {get, param} from '@loopback/rest';
import {PushNotificationService} from '../services/push-notification.service';

export class PushNotificationController {
  constructor(
    @inject('services.PushNotificationService')
    private pushNotificationService: PushNotificationService,
  ) {}

  @get('/send-push-notification')
  async sendPushNotification(
    @param.query.string('deviceToken') deviceToken: string,
    @param.query.string('message') message: string
  ): Promise<{success: boolean; message?: string}> {
    try {
      await this.pushNotificationService.sendNotification(deviceToken, message);
      return {success: true, message: 'Notification sent successfully'};
    } catch (error) {
      console.error('Error sending push notification:', error);
      return {success: false, message: error.message};
    }
  }
}
