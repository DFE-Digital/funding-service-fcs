@#Feature5066_Create_&_Publish_Funding_Policy/Configuration_data_to_DW

Feature: DeliverableSettingConfigurationAtomFeed

As a systems development manager, 
I want to make the intially configured Funding Stream Period data available to the Data Warehouse to support Provider Digital, 
so that the Provider Access Hub reports can be produced.

@AcceptanceTest @Withdrawn20221104
Scenario: E132 Ensure retrieved Funding Stream Deliverable settings atom feed contains all policy config in CRM
	When Funding Stream Deliverable settings are retrieved via atom feed
	Then all Funding Stream Deliverable settings from CRM policy config are present
