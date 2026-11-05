namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using Common;
    using Common.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractValidatorTests
    {
        private static CorporateContract.contract Master(int childCount, CorporateContract.hierarchyType hierarchy = CorporateContract.hierarchyType.MASTERCONTRACT, string status = "Draft")
        {
            var master = new CorporateContract.contract
            {
                hierarchyType = hierarchy,
                contracts = new List<CorporateContract.contractType>()
            };

            for (var i = 0; i < childCount; i++)
            {
                master.contracts.Add(new CorporateContract.contractType
                {
                    contractStatus = new CorporateContract.contractStatusType { status = status }
                });
            }

            return master;
        }

        [DataTestMethod, TestCategory("UnitTest")]
        [DataRow(null, "C1")]
        [DataRow("", "C1")]
        [DataRow("M1", null)]
        [DataRow("M1", "")]
        public void ValidateMasterAndChildContractNumber_Missing_ReturnsFalse(string master, string child)
        {
            Assert.IsFalse(ContractValidator.ValidateMasterAndChildContractNumber(master, child, out var error));
            Assert.AreEqual("Missing MasterContractNumber or ContractNumber", error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateMasterAndChildContractNumber_Present_ReturnsTrue()
        {
            Assert.IsTrue(ContractValidator.ValidateMasterAndChildContractNumber("M1", "C1", out var error));
            Assert.AreEqual(string.Empty, error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateMasterAndChildContracts_Null_ReturnsFalse()
        {
            Assert.IsFalse(ContractValidator.ValidateMasterAndChildContracts(null, out var error));
            Assert.AreEqual("ContractManageService called with null contract.", error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateMasterAndChildContracts_NoChildren_ReturnsFalse()
        {
            Assert.IsFalse(ContractValidator.ValidateMasterAndChildContracts(Master(0), out var error));
            Assert.AreEqual("ContractManageService called with no child contracts.", error);

            Assert.IsFalse(ContractValidator.ValidateMasterAndChildContracts(new CorporateContract.contract { contracts = null }, out error));
            Assert.AreEqual("ContractManageService called with no child contracts.", error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateMasterAndChildContracts_NotMaster_ReturnsFalse()
        {
            Assert.IsFalse(ContractValidator.ValidateMasterAndChildContracts(Master(1, CorporateContract.hierarchyType.CONTRACT), out var error));
            Assert.AreEqual("ContractManageService called with child contract.", error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateMasterAndChildContracts_MultipleChildren_ReturnsFalse()
        {
            Assert.IsFalse(ContractValidator.ValidateMasterAndChildContracts(Master(2), out var error));
            Assert.AreEqual("ContractManageService must be called with single child contract.", error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateMasterAndChildContracts_SingleChild_ReturnsTrue()
        {
            Assert.IsTrue(ContractValidator.ValidateMasterAndChildContracts(Master(1), out var error));
            Assert.AreEqual(string.Empty, error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateContractStatus_Valid_ReturnsTrue()
        {
            Assert.IsTrue(ContractValidator.ValidateContractStatus(Master(1, status: "Draft"), out var error));
            Assert.AreEqual(string.Empty, error);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateContractStatus_Invalid_ReturnsFalse()
        {
            Assert.IsFalse(ContractValidator.ValidateContractStatus(Master(1, status: "Bogus"), out var error));
            StringAssert.Contains(error, "Bogus is invalid");
        }
    }

    [TestClass]
    public class CorporateSchemaContractValidatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IsContractXmlValid_UnknownElement_ReturnsFalse()
        {
            Assert.IsFalse(CorporateSchemaContractValidator.IsContractXmlValid("<contract xmlns=\"urn:sfa:schemas:contract\"><nope/></contract>"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsContractXmlValid_UndeclaredRoot_ReturnsFalse()
        {
            Assert.IsFalse(CorporateSchemaContractValidator.IsContractXmlValid("<unknown xmlns=\"urn:sfa:schemas:contract\"/>"));
        }
    }
}
