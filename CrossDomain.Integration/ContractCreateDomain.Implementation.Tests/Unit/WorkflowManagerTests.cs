namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class WorkflowManagerTests
    {
        private readonly Guid _previousContract = new Guid("38b11529-c143-4210-8b52-57756c1cbb98");
        private readonly Guid _newContract = new Guid("a183a973-41f2-43bb-8e7b-0f220b18682a");

        [TestMethod, TestCategory("UnitTest")]
        public void WorkflowManager_GetWorkflowHistory_WhenContractIdIsEmptyReturnArgumentNullException()
        {
            // Arrange
            var workflowManager = new XrmWorkflowManager()
            {
                OrganizationService = null
            };

            try
            {
                // Act
                workflowManager.GetWorkflowHistory(Guid.Empty);

                // Assert
                Assert.Fail("Exception was not thrown for null IOrganizationService");
            }
            catch (ArgumentNullException ex)
            {
                // Assert
                Assert.IsNotNull(ex);
            }
            catch (Exception ex)
            {
                // Assert
                Assert.Fail("Exception was raised but not of correct type, type returned was: {0}", ex.GetType());
            }
        }


        [TestMethod, TestCategory("UnitTest")]
        public void WorkflowManager_TranslateWorkflowHistory_UpdateContractGuidsShouldReturnCorrectList()
        {

            // Arrange
            var workflowManager = new XrmWorkflowManager();

            var workflowHistoryList = new List<sfa_contracttransitionhistory>
            {
                new sfa_contracttransitionhistory
                {
                    Id = Guid.NewGuid(),
                    sfa_Contract = new EntityReference(sfa_contract.EntityLogicalName, _previousContract),
                },
                new sfa_contracttransitionhistory
                {
                    Id = Guid.NewGuid(),
                    sfa_Contract = new EntityReference(sfa_contract.EntityLogicalName, _previousContract)
                },
                new sfa_contracttransitionhistory
                {
                    Id = Guid.NewGuid(),
                    sfa_Contract = new EntityReference(sfa_contract.EntityLogicalName, _previousContract)
                }
            };

            // Act
            var newWorkflowHistory = workflowManager.TranslateWorkflowHistory(workflowHistoryList);

            // Assert
            Assert.IsTrue(
                newWorkflowHistory.TrueForAll(
                    w => w.Id == Guid.Empty && w.sfa_contracttransitionhistoryId == null),
                "Workflow History Guids have not been cleared");
            //Assert.IsTrue(newWorkflowHistory.TrueForAll(w => w.Attributes.Contains("overriddencreatedon")), "Created On has not been overriden");

        }
    }
}
