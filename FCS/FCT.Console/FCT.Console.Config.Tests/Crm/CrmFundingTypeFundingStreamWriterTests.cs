namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmFundingTypeFundingStreamWriterTests
    {
        private const string TestFundingStreamCode = "Test_FS";
        private const string TestFundingTypeCode = "Test_FT";

        [TestInitialize]
        public void Setup()
        {
            Guid? fundingTypeId = GetFundingTypeId(TestFundingTypeCode);
            if (!fundingTypeId.HasValue)
            {
                InsertFundingType(TestFundingTypeCode);
            }

            Guid? fundingStreamId = GetFundingStreamId(TestFundingStreamCode);
            if (!fundingStreamId.HasValue)
            {
                InsertFundingStream(TestFundingStreamCode);
            }
            sfa_fundingtype_fundingstream fundingTypeFundingstream = GetFundingTypeFundingStream(TestFundingStreamCode, TestFundingTypeCode);
            if (fundingTypeFundingstream != null)
            {
                CrmHelper.GetConnection().Delete(sfa_fundingtype_fundingstream.EntityLogicalName, fundingTypeFundingstream.Id);
            }
        }

        [TestCleanup]
        public void CleanUp()
        {
            Guid? fundingTypeId = GetFundingTypeId(TestFundingTypeCode);
            if (fundingTypeId != null)
            {
                CrmHelper.GetConnection().Delete(sfa_fundingtype.EntityLogicalName, fundingTypeId.Value);
            }

            Guid? fundingStreamId = GetFundingStreamId(TestFundingStreamCode);
            if (fundingStreamId != null)
            {
                CrmHelper.GetConnection().Delete(sfa_fundingstream.EntityLogicalName, fundingStreamId.Value);
            }

            sfa_fundingtype_fundingstream fundingTypeFundingstream = GetFundingTypeFundingStream(TestFundingStreamCode, TestFundingTypeCode);
            if (fundingTypeFundingstream != null)
            {
                CrmHelper.GetConnection().Delete(sfa_fundingtype_fundingstream.EntityLogicalName, fundingTypeFundingstream.Id);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeFundingStreamWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IReadOnlyCollection<FundingTypeStreamRelationshipSheetType> rows = GetRows();

            // act
            new CrmFundingTypeFundingStreamWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            sfa_fundingtype_fundingstream fundingTypeFundingstream = GetFundingTypeFundingStream(TestFundingStreamCode, TestFundingTypeCode);
            Assert.IsNotNull(fundingTypeFundingstream);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeFundingStreamWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndpolicyStatusIsDeleted()
        {
            // arrange
            IReadOnlyCollection<FundingTypeStreamRelationshipSheetType> rows = GetRows();
            new CrmFundingTypeFundingStreamWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFundingTypeFundingStreamWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            sfa_fundingtype_fundingstream fundingTypeFundingstream = GetFundingTypeFundingStream(TestFundingStreamCode, TestFundingTypeCode);
            Assert.IsNull(fundingTypeFundingstream);
        }


        private IReadOnlyCollection<FundingTypeStreamRelationshipSheetType> GetRows()
        {
            return new List<FundingTypeStreamRelationshipSheetType>
            {
                new FundingTypeStreamRelationshipSheetType
                {
                           
                    FundingTypeCode = TestFundingTypeCode,
                    FundingStreamCode = TestFundingStreamCode
                }
            };
        }

        private Guid? GetFundingTypeId(string fundingTypeCode)
        {
            sfa_fundingtype fundingtype;
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from ft in crmContext.sfa_fundingtypeSet
                                  where ft.sfa_fundingtypecode == fundingTypeCode
                                  select ft;
                fundingtype = entityQuery.FirstOrDefault();
            }

            return fundingtype?.Id;
        }

        private Guid? GetFundingStreamId(string fundingStreamCode)
        {
            sfa_fundingstream fundingstream;
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from fs in crmContext.sfa_fundingstreamSet
                                  where fs.sfa_fundingstreamcode == fundingStreamCode
                                  select fs;
                fundingstream = entityQuery.FirstOrDefault();
            }

            return fundingstream?.Id;
        }

        private void InsertFundingType(string fundingTypeCode)
        {
            var fundingTypeEntity = new sfa_fundingtype
            {
                sfa_fundingtypecode = fundingTypeCode
            };

            CrmHelper.GetConnection().Create(fundingTypeEntity);
        }

        private void InsertFundingStream(string fundingStreamCode)
        {
            var fundingStreamEntity = new sfa_fundingstream
            {
                sfa_fundingstreamcode = fundingStreamCode
            };

            CrmHelper.GetConnection().Create(fundingStreamEntity);
        }

        protected sfa_fundingtype_fundingstream GetFundingTypeFundingStream(string fundingStreamCode, string fundingTypeCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return (from ftfs in crmContext.sfa_fundingtype_fundingstreamSet
                    join ft in crmContext.sfa_fundingtypeSet on ftfs.sfa_fundingtypeid equals ft.sfa_fundingtypeId
                    join fs in crmContext.sfa_fundingstreamSet on ftfs.sfa_fundingstreamid equals fs.sfa_fundingstreamId
                    where ft.sfa_fundingtypecode == fundingTypeCode &&
                          fs.sfa_fundingstreamcode == fundingStreamCode
                    select ftfs).FirstOrDefault();
            }
        }
    }
}
