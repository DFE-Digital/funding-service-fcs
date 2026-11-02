using System;
using System.Text;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests.WorkflowConfiguration
{
    /// <summary>
    /// Summary description for XrmConfigurationUnitofWorkflowConfiguration
    /// IsPrimaryEntity(entityName)
    /// TriggerOnUpdateAttributeListContain
    /// IsSynchronousProcess(Mode =1)
    /// IsBackgroundProcess(Model =0)
    /// ProcessRunAs( RunAs=0 Th Owner of the workflow, RunAs=1 The Use who changed the record
    /// 
    /// </summary>
    [TestClass]
    public class XrmConfigurationUnitofWorkflowConfiguration : TestBase
    {

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF01ContractContractApprovalProcessConfigurationVerification()
        {
            CrmConfiguration.Workflow("WF01 Contract: Contract Approval Process")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }




        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF01ContractRecordImportedProcessConfigurationVerification()
        {
            CrmConfiguration.Workflow("WF01 Contract: Record Imported")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF01TaskOverrideProcessConfigurationVerification()
        {
            CrmConfiguration.Workflow("WF01: Task Override")
                .IsPrimaryEntity("task")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> {"ownerid"})
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF01TaskReassignProcessConfigurationVerification()
        {
            CrmConfiguration.Workflow("WF01 Task : Reassign")
                .IsPrimaryEntity("task")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF01TasksTaskCompletionProcessConfigurationVerification()
        {
            CrmConfiguration.Workflow("WF01 Tasks: Task Completion")
                .IsPrimaryEntity("task")
                .TriggerOnUpdateAttributeListContain(new List<String> { "statuscode","statecode" })
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF02A_UpdatePreviousContracttoReplacedProcessConfigurationVerification()
        {
            CrmConfiguration.Workflow("WF02a: Update Previous Contract to Replaced")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF02B_Contract_RequiresChangeOfOwnershipConfigVerification()
        {
            CrmConfiguration.Workflow("WF02b Contract: Requires Change Of Ownership")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF02C_Contract_RequiresCreationOfTaskConfigVerification()
        {
            CrmConfiguration.Workflow("WF02c Contract: Requires Creation Of Task")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF02_Contract_ProgressContractConfigVerification()
        {
            CrmConfiguration.Workflow("WF02 Contract: Progress Contract")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF02D_ContractrequiresANotificationConfigVerification()
        {
            CrmConfiguration.Workflow("WF02d: Contract requires a Notification")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF02E_WebApiCallRequiredConfigVerification()
        {
            CrmConfiguration.Workflow("WF02E: Web Api Call Required")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF02_TasksUpdatecontractontaskcompletionConfigVerification()
        {
            CrmConfiguration.Workflow("WF02 Tasks: Update contract on task completion")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF03_Contract_AllocateContractConfigVerification()
        {
            CrmConfiguration.Workflow("WF03 Contract: Allocate Contract")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }




        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF04A_Caseload_PreReassignConfigVerification()
        {
            CrmConfiguration.Workflow("WF04a Caseload: Pre-Reassign")
                .IsPrimaryEntity("sfa_caseload")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "ownerid" })
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF04_Caseload_ReassignConfigVerification()
        {
            CrmConfiguration.Workflow("WF04 Caseload: Reassign")
                .IsPrimaryEntity("sfa_caseload")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "ownerid" })
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }


        
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void  WF05_Contract_ReassignmentProcessConfigVerification()
        {
            CrmConfiguration.Workflow("WF05 Contract: Re-assignment Process")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "sfa_contractadviser" })
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }




        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF06_SystemUserChangeofPrimaryRoleConfigVerification()
        {
            CrmConfiguration.Workflow("WF06 System User Change of Primary Role")
                .IsPrimaryEntity("SystemUser")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "sfa_primaryrole" })
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF07_CreateNewDraftContractConfigVerification()
        {
            CrmConfiguration.Workflow("WF07 Create New Draft Contract")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF08_UpdateExistingDraftContractConfigVerification()
        {
            CrmConfiguration.Workflow("WF08 Update Existing Draft Contract")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF09_AmendContractConfigVerification()
        {
            CrmConfiguration.Workflow("WF09 Amend Contract")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF31_CallContractManagementServiceConfigVerification()
        {
            CrmConfiguration.Workflow("WF31: Call Contract Management Service(SB)")
                .IsPrimaryEntity("sfa_contract")
                .IsBackgroundProcess();

        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF12_SetAllocationIdfromAllocationReferenceConfigVerification()
        {
            CrmConfiguration.Workflow("WF12 Set Allocation Id from Allocation Reference")
                .IsPrimaryEntity("sfa_contractdeliverable")
                .IsBackgroundProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF14_Contract_StatusLastUpdatedDateConfigVerification()
        {
            CrmConfiguration.Workflow("WF14 Contract: Status Last Updated Date")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF15_UpdateContractApprovalDateConfigVerification()
        {
            CrmConfiguration.Workflow("WF15: Update Contract Approval Date")
                .IsPrimaryEntity("sfa_contract")
                .IsBackgroundProcess()
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF16_DocumentManagementServiceUpdateConfigVerification()
        {
            CrmConfiguration.Workflow("WF16: Document Management Service Update")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "sfa_serviceresponse" })
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }




        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF17_DocumentManagementAssignmentConfigVerification()
        {
            CrmConfiguration.Workflow("WF17: Document Management Assignment")
                .IsPrimaryEntity("sfa_contract")
                .IsBackgroundProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "ownerid" })
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF18_SetContractApprovalDateConfigVerification()
        {
            CrmConfiguration.Workflow("WF18: Set Contract Approval Date")
                .IsPrimaryEntity("sfa_contract")
                .IsBackgroundProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void WF2a_ContractActionOnExistingTaskConfigVerification()
        {
            CrmConfiguration.Workflow("WF2a Contract: Action On Existing Task")
                .IsPrimaryEntity("sfa_contract")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theowneroftheworkflow);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void GenerateContractNumberConfigVerification()
        {
            CrmConfiguration.Workflow("Generate Contract Number")
                .IsPrimaryEntity("sfa_contractnumber")
                .IsBackgroundProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void SetContractAllocationReferenceConfigVerification()
        {
            CrmConfiguration.Workflow("Set Contract Allocation Reference")
                .IsPrimaryEntity("sfa_contractdeliverable")
                .IsBackgroundProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void SetDeliverableNameConfigVerification()
        {
            CrmConfiguration.Workflow("Set  Deliverable Name")
                .IsPrimaryEntity("sfa_deliverable")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "sfa_deliverablename", "sfa_deliverablecode" })
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void SetFundingStreamPeriodDeliverableNameConfigVerification()
        {
            CrmConfiguration.Workflow("Set Funding Stream Period Deliverable Name")
                .IsPrimaryEntity("sfa_fundingstreamperioddeliverable")
                .IsSynchronousProcess()
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "")]
        public void SetPeriodNameConfigVerification()
        {
            CrmConfiguration.Workflow("Set Period Name")
                .IsPrimaryEntity("sfa_period")
                .IsSynchronousProcess()
                .TriggerOnUpdateAttributeListContain(new List<String> { "sfa_periodtypeid", "sfa_period" })
                .ProcessRunAs(WorkflowRunAs.Theuserwhomadechangestotherecord);
        }


    }
}
