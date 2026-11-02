namespace FCT.Operations.Cda.Tests.Dtos
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FCT.Operations.Cda.Dtos;

    [TestClass]
    public class CdaRowTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CdaRow_ShouldTextQualifySpecificProperties()
        {
            // Arrange & Act 
            var cdaRow = new CdaRow
            {
                ContractNumber = "ContractNumber",
                Deliverable = "Deliverable",
                DeliverableDescription = "DeliverableDescription",
                DeliverableParent = "DeliverableParent",
                ProviderName = "ProviderName",
                DeliveryProviderName = "DeliveryProviderName"
            };

            // Assert
            // Non text qualified property
            Assert.AreEqual("ContractNumber", cdaRow.ContractNumber, "Contract Number not returned correctly");
            // Text qualified properties
            Assert.AreEqual("\"Deliverable\"", cdaRow.Deliverable, "Deliverable not returned correctly");
            Assert.AreEqual("\"DeliverableDescription\"", cdaRow.DeliverableDescription, "DeliverableDescription not returned correctly");
            Assert.AreEqual("\"DeliverableParent\"", cdaRow.DeliverableParent, "DeliverableParent not returned correctly");
            Assert.AreEqual("\"ProviderName\"", cdaRow.ProviderName, "ProviderName not returned correctly");
            Assert.AreEqual("\"DeliveryProviderName\"", cdaRow.DeliveryProviderName, "DeliveryProviderName not returned correctly");
        }
    }
}