using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    [TestClass]
    public class EnrichedReportedActualEquatableTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ConcatenateIEnumerableOfReportedActual_ShouldOverwriteList1OntoList2()
        {
            var list1 = new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 1
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 1
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "3",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 1
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "2",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 1
                },
                 new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "2",
                    Period = "201508",
                    ContractVersion = 1
                }
            };

            var list2 = new List<EnrichedReportedActual>
            {
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 1
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "2",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 2
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "3",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 2
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "2",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201508",
                    ContractVersion = 2
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "2",
                    Period = "201508",
                    ContractVersion = 2
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "2",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "1",
                    Period = "201509",
                    ContractVersion = 2
                },
                new EnrichedReportedActual
                {
                    OrganisationId = "1",
                    FundingStreamPeriodCode = "1",
                    UoPCode = "1",
                    DeliverableCode = "2",
                    Period = "201509",
                    ContractVersion = 2
                }
            };

            var resultlist = list1.Concat(list2.Except(list1));

            var enrichedReportedActuals = resultlist as EnrichedReportedActual[] ?? resultlist.ToArray();

            Assert.AreEqual(7, enrichedReportedActuals.Count());

            Assert.AreEqual(5, enrichedReportedActuals.Count(l => l.ContractVersion == 1));

            Assert.AreEqual(2, enrichedReportedActuals.Count(l => l.ContractVersion == 2));

            foreach (var a in enrichedReportedActuals)
            {
                Console.WriteLine("Org Id: {0}, FSP: {1}, Uop: {2}, DeliverableCode: {3}, Period: {4}, Version: {5}",
                    a.OrganisationId,
                    a.FundingStreamPeriodCode,
                    a.UoPCode,
                    a.DeliverableCode,
                    a.Period,
                    a.ContractVersion);
            }
        }
    }
}
