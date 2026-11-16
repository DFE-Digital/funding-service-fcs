namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.unit
{
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Persistence;

    [TestClass]
    public class FieldMapperTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldGetMappingForContractField()
        {
            var mappings = CrmFieldMapper.GetMappings("contract", "startDate");
            Assert.IsTrue(mappings != null);
            Assert.IsTrue(mappings.ToArray().Length > 0 );
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldGetTwoMappingsForDeliveryOrganisation()
        {
            var mappings = CrmFieldMapper.GetMappings("contractAllocationsContractAllocation", "DeliveryOrganisation");
            Assert.AreEqual(2, mappings.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldReturnNoMappingsForUnknownClassOrProperty()
        {
            Assert.AreEqual(0, CrmFieldMapper.GetMappings("unknown", "startDate").Count());
            Assert.AreEqual(0, CrmFieldMapper.GetMappings("contract", "unknown").Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldGetPrimaryKeyValueForSupportedLookupTypes()
        {
            Assert.AreEqual(
                "AY1718",
                CrmFieldMapper.GetPrimaryKeyFieldValue(new CorporateContract.Period
                {
                    period1 = "1718",
                    periodType = new CorporateContract.periodTypeType
                    {
                        periodTypeCode = CorporateContract.periodTypeCodeType.AY
                    }
                }));
            Assert.AreEqual("12345678", CrmFieldMapper.GetPrimaryKeyFieldValue(new CorporateContract.Contractor { ukprn = 12345678 }));
            Assert.AreEqual("AGE", CrmFieldMapper.GetPrimaryKeyFieldValue(new CorporateContract.fundingType { fundingTypeCode = "AGE" }));
            Assert.AreEqual("AEB", CrmFieldMapper.GetPrimaryKeyFieldValue(new CorporateContract.fundingStream { fundingStreamCode = "AEB" }));
            Assert.AreEqual("Approved", CrmFieldMapper.GetPrimaryKeyFieldValue(new CorporateContract.contractStatusType { status = "Approved" }));
            Assert.AreEqual("AY", CrmFieldMapper.GetPrimaryKeyFieldValue(CorporateContract.periodTypeCodeType.AY));
            Assert.AreEqual(
                "FY",
                CrmFieldMapper.GetPrimaryKeyFieldValue(new CorporateContract.periodTypeType
                {
                    periodTypeCode = CorporateContract.periodTypeCodeType.FY
                }));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldReturnNullForUnsupportedOrNullPrimaryKeyValues()
        {
            Assert.IsNull(CrmFieldMapper.GetPrimaryKeyFieldValue(null));
            Assert.IsNull(CrmFieldMapper.GetPrimaryKeyFieldValue(new object()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldCreatePeriodCompositeKeyOnlyWhenPeriodIsProvided()
        {
            var emptyKey = CrmFieldMapper.GetPeriodPk(null);
            Assert.AreEqual(0, emptyKey.KeyFields.Count);

            var key = CrmFieldMapper.GetPeriodPk(new CorporateContract.Period
            {
                period1 = "1718",
                periodType = new CorporateContract.periodTypeType
                {
                    periodTypeCode = CorporateContract.periodTypeCodeType.AY
                }
            });

            Assert.AreEqual(2, key.KeyFields.Count);
            Assert.AreEqual("sfa_period", key.KeyFields[0].Column);
            Assert.AreEqual("1718", key.KeyFields[0].Value);
            Assert.AreEqual("sfa_period", key.KeyFields[0].Table);
            Assert.AreEqual("sfa_periodtypecode", key.KeyFields[1].Column);
            Assert.AreEqual(CorporateContract.periodTypeCodeType.AY, key.KeyFields[1].Value);
            Assert.AreEqual("sfa_periodtype", key.KeyFields[1].Table);
            Assert.AreEqual("pt", key.KeyFields[1].Alias);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmFieldMapper_ShouldCreateFundingStreamPeriodCompositeKey()
        {
            var key = CrmFieldMapper.GetFundingStreamPeriodPk(new CorporateContract.contractAllocationsContractAllocation
            {
                period = new CorporateContract.Period
                {
                    period1 = "1718",
                    periodType = new CorporateContract.periodTypeType
                    {
                        periodTypeCode = CorporateContract.periodTypeCodeType.AY
                    }
                },
                fundingStream = new CorporateContract.fundingStream { fundingStreamCode = "AEB" }
            });

            Assert.AreEqual(3, key.KeyFields.Count);
            Assert.AreEqual("sfa_period", key.KeyFields[0].Column);
            Assert.AreEqual("1718", key.KeyFields[0].Value);
            Assert.AreEqual("p", key.KeyFields[0].Alias);
            Assert.AreEqual("sfa_fundingstreamcode", key.KeyFields[1].Column);
            Assert.AreEqual("AEB", key.KeyFields[1].Value);
            Assert.AreEqual("fs", key.KeyFields[1].Alias);
            Assert.AreEqual("sfa_periodtypecode", key.KeyFields[2].Column);
            Assert.AreEqual(CorporateContract.periodTypeCodeType.AY, key.KeyFields[2].Value);
            Assert.AreEqual("pt", key.KeyFields[2].Alias);
        }
    }
}
