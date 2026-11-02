namespace Datafix.Tests.ServiceTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmToContractInformationStatusTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmToContractInformationStatusTransformer_TransformContractStatus_ShouldCorrectlyTransformCrmContractStatuses()
        {
            Assert.AreEqual(ContractStatus.Approved, CrmToContractInformationStatusTransformer.TransformContractStatus(sfa_contractstatus.Approved));
            Assert.AreEqual(ContractStatus.Closed, CrmToContractInformationStatusTransformer.TransformContractStatus(sfa_contractstatus.Closed));
            Assert.AreEqual(ContractStatus.Draft, CrmToContractInformationStatusTransformer.TransformContractStatus(sfa_contractstatus.Draft));

            Assert.AreEqual(ContractStatus.Other, CrmToContractInformationStatusTransformer.TransformContractStatus(sfa_contractstatus.Replaced));
            Assert.AreEqual(ContractStatus.Other, CrmToContractInformationStatusTransformer.TransformContractStatus(sfa_contractstatus.SupersededDraft));
            Assert.AreEqual(ContractStatus.Other, CrmToContractInformationStatusTransformer.TransformContractStatus(sfa_contractstatus.Withdrawn));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmToContractInformationStatusTransformer_TransformContractSubStatus_ShouldCorrectlyTransformCrmContractSubStatuses()
        {
            Assert.AreEqual(ContractSubStatus.Approved, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Approved"));
            Assert.AreEqual(ContractSubStatus.AwaitingClosureApproval, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Awaiting Closure Approval"));
            Assert.AreEqual(ContractSubStatus.Closed, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Closed"));
            Assert.AreEqual(ContractSubStatus.ClosureinProgress, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Closure in Progress"));
            Assert.AreEqual(ContractSubStatus.ClosureInitiationinProgress, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Closure Initiation in Progress"));
            Assert.AreEqual(ContractSubStatus.PublishedtoProvider, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Published to Provider"));
            Assert.AreEqual(ContractSubStatus.AwaitingTerminationInitiationApproval, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Awaiting Termination Initiation Approval"));
            Assert.AreEqual(ContractSubStatus.UnderTermination, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Under Termination"));

            Assert.AreEqual(ContractSubStatus.Other, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Document Merge In Progress"));
            Assert.AreEqual(ContractSubStatus.Other, CrmToContractInformationStatusTransformer.TransformContractSubStatus("Withdrawn By Agency"));
        }
    }
}
