namespace OrganisationDomain.Implementation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Implementation.Services;
    using Integration.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class OrgSupplementaryDataServiceTestImplTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public async Task OrgSupplementaryDataServiceTestImpl_ShouldReturnSuccessfullyWhenUkprnDoesNotHaveSpecialPrefix()
        {
            const int ukprn = 1234;

            IOrgSupplementaryDataService orgSupplementaryDataServiceTestImpl = new OrgSupplementaryDataServiceTestImpl(Mock.Of<IAzureTableStore>());
            
            // act
            OrgSupplementaryDataServiceResult orgSupplementaryDataServiceResult = await orgSupplementaryDataServiceTestImpl.GetDataForUkprn(ukprn);

            // assert
            Assert.AreEqual(true, orgSupplementaryDataServiceResult.IsSuccessful);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task OrgSupplementaryDataServiceTestImpl_ShouldReturnUnSuccessfulWhenUkprnDoesHaveSpecialPrefix()
        {
            const int ukprn = 99991;

            IOrgSupplementaryDataService orgSupplementaryDataServiceTestImpl = new OrgSupplementaryDataServiceTestImpl(Mock.Of<IAzureTableStore>());

            // act
            OrgSupplementaryDataServiceResult orgSupplementaryDataServiceResult = await orgSupplementaryDataServiceTestImpl.GetDataForUkprn(ukprn);

            // assert
            Assert.AreEqual(false, orgSupplementaryDataServiceResult.IsSuccessful);
        }

        [TestMethod, TestCategory("DataDependentExploratoryDAT")]
        public async Task OrgSupplementaryDataServiceTestImpl_GetSupplementaryDataChanges_ShouldReturnDataFromStub()
        {
            // arrange
            IOrgSupplementaryDataService orgSupplementaryDataServiceTestImpl = new OrgSupplementaryDataServiceTestImpl(new AzureTableStore());

            // act
            IReadOnlyCollection<OrgSupplementaryData> supplementaryDataChanges = await orgSupplementaryDataServiceTestImpl.GetSupplementaryDataChanges();

            // assert
            Assert.IsNotNull(supplementaryDataChanges);
            Assert.AreEqual(7, supplementaryDataChanges.Count);

            int[] expectedUkprns = {10018101, 10018112, 10018123, 10018134, 10018145, 10018156};
            expectedUkprns.ForEach(ukprn => Assert.IsNotNull(supplementaryDataChanges.SingleOrDefault(s => s.Ukprn == ukprn)));

            Assert.AreEqual("AA018134", supplementaryDataChanges.Single(s => s.Ukprn == 10018134).CompanyNumber);
            Assert.IsNull(supplementaryDataChanges.Single(s => s.Ukprn == 10018123).CompanyNumber);
        }

        [TestMethod, TestCategory("DataDependentExploratoryDAT")]
        public async Task OrgSupplementaryDataServiceTestImpl_GetDataForUkprn_ShouldReturnDataFromStub()
        {
            // arrange
            IOrgSupplementaryDataService orgSupplementaryDataServiceTestImpl = new OrgSupplementaryDataServiceTestImpl(new AzureTableStore());

            // act
            OrgSupplementaryDataServiceResult result1 = await orgSupplementaryDataServiceTestImpl.GetDataForUkprn(10018112);
            OrgSupplementaryDataServiceResult result2 = await orgSupplementaryDataServiceTestImpl.GetDataForUkprn(10018156);

            // assert
            Assert.IsNotNull(result1);
            Assert.AreEqual("18112", result1.CharityNumber);
            Assert.AreEqual("PQ018112", result1.CompanyRegNumber);
            Assert.IsNotNull(result1.LegalAddress);
            Assert.AreEqual("74", result1.LegalAddress.Line1);
            Assert.AreEqual("Warwick Road", result1.LegalAddress.Line2);
            Assert.IsNull(result1.LegalAddress.Line3);
            Assert.IsNull(result1.LegalAddress.Line4);
            Assert.AreEqual("Kenilworth", result1.LegalAddress.Town);
            Assert.AreEqual("Warwickshire", result1.LegalAddress.County);
            Assert.AreEqual("CV8 1HL", result1.LegalAddress.Postcode);

            Assert.IsNotNull(result2);
            Assert.AreEqual("18156", result2.CharityNumber);
            Assert.AreEqual("00018156", result2.CompanyRegNumber);
            Assert.IsNotNull(result2.LegalAddress);
            Assert.IsNull(result2.LegalAddress.Line1);
            Assert.IsNull(result2.LegalAddress.Line2);
            Assert.IsNull(result2.LegalAddress.Line3);
            Assert.IsNull(result2.LegalAddress.Line4);
            Assert.IsNull(result2.LegalAddress.Town);
            Assert.IsNull(result2.LegalAddress.County);
            Assert.IsNull(result2.LegalAddress.Postcode);
        }
    }
}
