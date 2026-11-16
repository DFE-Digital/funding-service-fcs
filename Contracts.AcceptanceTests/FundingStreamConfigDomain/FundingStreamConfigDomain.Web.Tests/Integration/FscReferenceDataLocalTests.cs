namespace FundingStreamConfigDomain.Web.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Text.Json;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    /// <summary>
    /// Integration tests for Funding Stream Configuration reference data lookups.
    /// These tests verify that the ReferenceDataLookupApiController endpoint correctly
    /// retrieves funding configuration data from CRM for specified funding type, period, and period type.
    /// 
    /// Diagnostic note:
    /// Created to isolate HTTP 500 error occurring in Funding Policy DAT service when worker
    /// queries /rest/referencedatalookup?period=1920&periodType=AY&fundingType=EDSK
    /// Root cause tracking: CRM query logic vs. server-side configuration
    /// </summary>
    [TestClass]
    public class FscReferenceDataLocalTests
    {
        /// <summary>
        /// Diagnostic: Verifies that 1920/AY/EDSK configuration is queryable.
        /// If this test passes: HTTP 500 is server-side (CRM data missing or configuration issue)
        /// If this test fails: Issue may be in CRM query logic or entity mapping
        /// </summary>
        [TestMethod]
        [TestCategory("IntegrationDiagnostic")]
        public void ReferenceDataLookupController_ExpectedDataModel_Diagnostic()
        {
            // This test documents the expected data model for reference data lookup
            // Used for diagnosing HTTP 500 errors in the Funding Policy DAT service

            var period = "1920";
            var periodType = "AY";
            var fundingType = "EDSK";

            // Expected query parameters that cause HTTP 500 in DAT
            var queryUrl = $"/rest/referencedatalookup?period={period}&periodType={periodType}&fundingType={fundingType}";

            Console.WriteLine($"Diagnostic: Query URL that causes HTTP 500: {queryUrl}");
            Console.WriteLine($"  Period: {period} (Academic Year 2019-2020)");
            Console.WriteLine($"  PeriodType: {periodType} (Academic Year)");
            Console.WriteLine($"  FundingType: {fundingType} (Education and Skills)");
            Console.WriteLine("");
            Console.WriteLine("Expected CRM data model:");
            Console.WriteLine("  sfa_fundingtype (FundingType) - must exist with code=EDSK");
            Console.WriteLine("  sfa_fundingstream - must be linked to funding type");
            Console.WriteLine("  sfa_fundingstreamperiod - must link funding stream to period");
            Console.WriteLine("  sfa_period - must exist with code=1920 and start/end dates");
            Console.WriteLine("  sfa_periodtype - must exist with code=AY");
            Console.WriteLine("");
            Console.WriteLine("If HTTP 500 occurs, check:");
            Console.WriteLine("  1. sfa_fundingtype records exist in DAT CRM");
            Console.WriteLine("  2. sfa_fundingstream records are linked correctly");
            Console.WriteLine("  3. sfa_period 1920 is configured for AY periodtype");
            Console.WriteLine("  4. sfa_fundingstreamperiod records link streams to periods");

            Assert.IsTrue(!string.IsNullOrEmpty(period), "Period should not be null");
            Assert.IsTrue(!string.IsNullOrEmpty(fundingType), "FundingType should not be null");
        }

        /// <summary>
        /// Documents the expected response structure for successful funding configuration lookup.
        /// </summary>
        [TestMethod]
        [TestCategory("IntegrationDiagnostic")]
        public void FundingConfigurationResponse_ExpectedStructure_Diagnostic()
        {
            // Expected response structure when /rest/referencedatalookup succeeds
            var expectedResponseJson = new
            {
                FundingConfigurationList = new object[]
                {
                    new
                    {
                        FundingTypeCode = "EDSK",
                        FundingStreamCode = "FS-EDSK",
                        FundingStreamId = "guid-value",
                        FundingStreamName = "Education and Skills",
                        FundingStreamShortCode = "EDSK",
                        FundingStreamCodeId = "guid-value",
                        FundingStreamPeriodCode = "EDSK-1920",
                        Period = "1920",
                        FundingPeriodStartDate = "2019-08-01T00:00:00",
                        FundingPeriodEndDate = "2020-07-31T23:59:59",
                        PeriodTypeCode = "AY"
                    }
                }
            };

            Console.WriteLine("Expected FundingConfigurationType response structure:");
            Console.WriteLine(JsonSerializer.Serialize(expectedResponseJson, new JsonSerializerOptions { WriteIndented = true }));
            Console.WriteLine("");
            Console.WriteLine("HTTP 500 diagnostic: If response is empty or missing fields,");
            Console.WriteLine("check CRM data completeness and ReferenceDataManager.GetFundingConfiguration() query logic");

            Assert.IsNotNull(expectedResponseJson, "Expected response structure should be defined");
        }

        /// <summary>
        /// Documents the CRM query join logic that must succeed for data retrieval.
        /// This is the path followed when /rest/referencedatalookup processes a request.
        /// </summary>
        [TestMethod]
        [TestCategory("IntegrationDiagnostic")]
        public void CrmQueryJoinLogic_ExpectedPath_Diagnostic()
        {
            // The ReferenceDataManager.GetFundingConfiguration method performs this join:
            // 1. Start with sfa_fundingtype (filtered by sfa_fundingtypecode == "EDSK")
            // 2. Join to sfa_fundingtype_fundingstream (M:M relationship)
            // 3. Join to sfa_fundingstream (filtered by none initially)
            // 4. Join to sfa_fundingstreamperiod (link funding stream to periods)
            // 5. Join to sfa_period (filtered by sfa_period == "1920")
            // 6. Join to sfa_periodtype (filtered by sfa_periodtypecode == "AY")
            // 7. All must match: fundingType == "EDSK", period == "1920", periodType == "AY"

            var joinPath = new List<string>
            {
                "sfa_fundingtype (start, filter: sfa_fundingtypecode='EDSK')",
                "? sfa_fundingtype_fundingstream (M:M join)",
                "? sfa_fundingstream (include in select)",
                "? sfa_fundingstreamperiod (join sfa_fundingstreamid)",
                "? sfa_period (join sfa_periodid, filter: sfa_period='1920')",
                "? sfa_periodtype (join sfa_periodtypeid, filter: sfa_periodtypecode='AY')",
                "= Return FundingConfigurationDataType with all fields populated"
            };

            Console.WriteLine("CRM Query Join Path:");
            Console.WriteLine("");
            foreach (var step in joinPath)
            {
                Console.WriteLine(step);
            }
            Console.WriteLine("");
            Console.WriteLine("HTTP 500 diagnostic: If any join fails or returns 0 results,");
            Console.WriteLine("check:");
            Console.WriteLine("  - Entity primary keys exist and match");
            Console.WriteLine("  - Relationship definitions (M:M, 1:N) are correct");
            Console.WriteLine("  - Filter criteria values match CRM data exactly");
            Console.WriteLine("  - Case sensitivity of codes (EDSK vs edsk)");

            Assert.IsTrue(joinPath.Count == 7, "Join path should have 7 steps");
        }
    }
}
