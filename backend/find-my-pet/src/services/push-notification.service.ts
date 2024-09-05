/*import * as apn from 'apn';

// Configure the APN provider
const apnProvider = new apn.Provider({
  token: {
    key: 'AuthKey_W32TBY97AN.p8',
    keyId: 'W32TBY97AN',
    teamId: 'KH7BD93PMV',
  },
  production: false,
});

export class PushNotificationService {
  // Function to send push notification
  async sendNotification(deviceToken: string, alert: string): Promise<void> {
    // Call the sendPushNotification function
    return sendPushNotification(deviceToken, alert)
      .then(() => console.log("Notification sent successfully!"))
      .catch((error) => {
        console.error("Error sending notification:", error);
        throw error;
      });
  }
}

// Function to send push notification to a user
function sendPushNotification(deviceToken: string, notificationMessage: string): Promise<void> {
  // Check if the device token is available
  if (!deviceToken) {
    console.error('Device token not found');
    return Promise.reject(new Error('Device token not found'));
  }

  // Create a notification
  const notification = new apn.Notification();
  notification.alert = notificationMessage;
  notification.sound = 'default';
  notification.badge = 1;
  notification.topic = 'nl.fontys.prj323.FindMyPet';

  // Send the notification
  return apnProvider.send(notification, deviceToken)
    .then((result) => {
      console.log('Push notification sent successfully:', result);
    })
    .catch((error) => {
      console.error('Error sending push notification:', error);
      throw error; // Re-throw the error for further handling
    });
}*/
//END 


//BEGIN

/*import * as apn from 'apn';

export class PushNotificationService {
    private apnProvider: apn.Provider;
  
    constructor() {
      this.apnProvider = new apn.Provider({
        token: {
          key: 'AuthKey_W32TBY97AN.p8', // Path to the key file
          keyId: 'W32TBY97AN', // Key ID
          teamId: 'KH7BD93PMV', // Developer Team ID
        },
        production: false // Set to true in production
      });
    }
  
    async sendNotification(deviceToken: string, alert: string): Promise<void> {
      let note = new apn.Notification();
      //note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now
      note.badge = 1;
      note.sound = 'default'; //ping.aiff';
      note.alert = alert;
      note.payload = {'messageFrom': 'Find My Pet'};
      note.topic = 'nl.fontys.prj323.FindMyPet'; // Your app bundle ID
  
      try {
        await this.apnProvider.send(note, deviceToken);
        console.log("Notification sent successfully!");
        //console.log("Sent to:", response.sent);
       // console.log("Failed:", response.failed);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    }
}*/

//END


//BEGIN

import * as apn from 'apn';

export class PushNotificationService {
    private apnProvider: apn.Provider;

    constructor() {
        this.apnProvider = new apn.Provider({
            token: {
                key: 'src/services/AuthKey_W32TBY97AN.p8',
                keyId: 'W32TBY97AN',
                teamId: 'KH7BD93PMV',
            },
            production: false
        });
    }

    async sendNotification(deviceToken: string, alert: string) {
        if (!deviceToken) {
            throw new Error('Device token not found');
        }

        let notification = new apn.Notification();
        notification.badge = 1;
        notification.sound = 'default';
        notification.alert = alert;
        //notification.payload = {'messageFrom': 'Find My Pet'};
        notification.topic = 'nl.fontys.prj323.FindMyPet';

        return this.apnProvider.send(notification, deviceToken)
        .then((result) => {
          console.log('Push notification sent successfully:' + result);
        })
        .catch((error) => {
          console.error('Error sending push notification:', error);
          throw error; // Re-throw the error for further handling
        });
    }
}
