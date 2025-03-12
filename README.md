# Videoengager's SmartVideo package for Salesforce

VideoEngage Salesforce companion component used to enhance CTI with video calling capabilites

# Installation

## One click
Andrew Fawcett's solution for one click install

<a href="https://githubsfdeploy.herokuapp.com?ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

> **_NOTE:_** If you encounter an error like `Could not find the repository 'LightningVeComponent'. Ensure it is spelt correctly and that it is owned by 'VideoEngager'`, make sure that the `Repository` field contains only `LightningVeComponent`

## Manual via CLI

### In Dev/Sandbox/Prod org

1. Authorize your org with and set it an alias (**myorg**) if it is not:
    ```
    sf org login web -d -a myorg
    ```

    Optionally you can add your instance url:

    ```
    sf org login web -d -a myorg --instance-url https://........my.salesforce.com/
    ```

    [Read more.](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_web_flow.htm)

1. Clone the repository:

    ```
    git clone https://github.com/VideoEngager/LightningVeComponent.git
    cd LightningVeComponent
    ```
1. Push the code to your org (**myorg**):

    ```
    sf project deploy start -o myorg
    ```

    Optionally, you can limit the tests to the ones in this project with the following command:

    ```
    sf project deploy start -o myorg -l RunSpecifiedTests -t SmartvideoControllerTest
    ```

    [Read more.](https://developer.salesforce.com/docs/atlas.en-us.254.0.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_deploy_start_unified)

1. Open the org from CLI (**myorg**):

    ```
    sf org open -o myorg
    ```
    [Read more.](https://developer.salesforce.com/docs/atlas.en-us.254.0.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_open_unified)
### In a Scratch Org

1. Authorize your devhub org with and set it an alias (**mydevhub**):

    ```
    sf org login web -d -a mydevhub
    ```

1. Clone the repository:

    ```
    git clone https://github.com/VideoEngager/LightningVeComponent.git
    cd LightningVeComponent
    ```

1. Create scratch org and set an alias (**LightningVeComponent**):

    ```
    sf org create scratch -d -f config/project-scratch-def.json -a LightningVeComponent
    ```

1. Push the code to your scratch org:

    ```
    sf project deploy start
    ```

1. Open the scratch org from CLI:

    ```
    sf org open
    ```

## Configuration

### 1. SmartVideo settings (mandatory)

This setting is optional and may only need to be changed if you have been instructed to do so. This operation requires Salesforce Administrator.

1. Login into your org
1. Open Setup and search for `custom metadata types`

   ![setup-cmdt](assets/setup-cmdt-nav.png)
1. Locate `Smartvideo Setting` custom metadata type and click `Manage Records`

   ![smartvideo-settings](assets/smartvideo-cmdt.png)
1. Locate record `API Key`, click `edit` and put the provided API key into `Value`.
1. Optional: Locate record `Environment`, click `Edit` and put provided value into `Value`
1. Optional: Talkdesk setup requires `Environment` to be `talkdesk` and `Talkdesk installation ID` to be populated accordingly.

### 2. Setting up permissions (mandatory)

To perform this operation, you need Salesforce Administrator privileges.

1. Log in to your Salesforce organization.
1. Open Setup, search for `permission sets` and click on result.
1. In the `Permission Sets` list, locate the `SmartVideo` permission set and click on it.
1. Click the `Manage Assignments` button.
1. To assign this permission set to a user, click `Add Assignmnet` and select the desired users. You can also modify existing assignments from the list.

### 3. Adding SmartVideo to Salesforce Utility Bar (mandatory)

To perform this operation, you need Salesforce Administrator privileges.

1. Log in to your Salesforce organization.
1. Open Setup, search for `App manager` and click on result.
1. In `Lightning Experience App Manager` you should locate your target Application where you want to install this component. `App type` should be `Lightning`. Click `Edit` from action button on your App (For example `Sales`).
1. In `Lightning App Builder` locate `App Settings` and choose `Utility Items (Desktop Only)`
1. Click on `Add Utility Item` button and search for `smartvideo`.
  
    ![add-smartvideo-to-utility-bar](assets/search-add-smartvideo-to-utilitybar.png)

1. In the properties of the component mark `Start automatically` checkbox.
1. Additionally, you can choose another label and other icon
1. Once you are finished with setting you should click `Save` button.
1. On your home page, make sure you're in the same App you changed to add the Smartvideo component (like `Sales`).
1. If successful, you will see our component in the utility bar below and you can start making video calls.
  
    ![smartvideo-in-utilitybar](assets/smartvideo-component-in-utilitybar.png)

1. And if you click on that button it will open the component
    
    ![smartvideo](assets/smartvideo.png)

### 3. Examples

## 1. Handling all SmartVideo events and printing them into the debug log.

Example code could be found in `force-app/main/default/classes/examples/SmartVideoEventTrigger.trigger`
This is a trigger handler that will fire when our SmartVideo event is sent to all subscribers.
It will dump the basic information to the debug log.
Make sure you enable debug logs for `Automated Process`, otherwise nothing will be logged.
The event payload is stored in the `Payload__c` field as a string that is JSON.
In `Name__c` you will find the payload type or event name.
