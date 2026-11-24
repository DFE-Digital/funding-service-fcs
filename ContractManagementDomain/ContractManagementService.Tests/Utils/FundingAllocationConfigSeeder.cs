namespace SFA.FCT.ContractManagementService.Test.Utils
{
    using System.Data.SqlClient;
    using global::ContractManagementService.Tests;

    // Idempotently inserts the AY-2526 ASF reference data these tests read, because other
    // suites in the shared DCI database can wipe the FundingAllocation config tables.
    public static class FundingAllocationConfigSeeder
    {
        private const string SeedSql = @"
SET XACT_ABORT ON;
BEGIN TRANSACTION;

INSERT INTO [FundingAllocation].[FspDeliverableConfig] ([FspCode], [DeliverableCode], [DeliverableName])
SELECT v.FspCode, v.DeliverableCode, v.DeliverableName
FROM (VALUES
    ('ASF2023-FCFJ2526', 2,  'NSF Free Courses for Jobs'),
    ('ASF2023-FCFJ2526', 5,  'NSF Free Courses for Jobs Learner Support'),
    ('ASF2023-AS2526',   4,  'Adult Skills'),
    ('ASF2023-AS2526',   5,  'Adult Skills Learner Support'),
    ('ASFC-ASCL2526',    2,  'Adult Skills Total Funding'),
    ('ASFC-ASCL2526',    5,  'Tailored Learning'),
    ('ASFC-ASCL2526',    12, 'Funding for Innovative Provision'),
    ('ASFC-FCFJ2526',    2,  'NSF Free Courses for Jobs')
) AS v(FspCode, DeliverableCode, DeliverableName)
WHERE NOT EXISTS (
    SELECT 1 FROM [FundingAllocation].[FspDeliverableConfig] f
    WHERE f.FspCode = v.FspCode AND f.DeliverableCode = v.DeliverableCode);

INSERT INTO [FundingAllocation].[AllocationFundingStreamConfig]
    ([AllocationFundingStreamCode], [AllocationPeriodId], [FundingTypeCode], [FundingPeriodCode], [FSPGroupCode])
SELECT v.Code, v.PeriodId, v.FundingTypeCode, v.FundingPeriodCode, v.FSPGroupCode
FROM (VALUES
    ('ASFC', 'AY-2526', 'AEB2023', 'AY2526', 'ASF2023_2526'),
    ('ASFG', 'AY-2526', 'EDSK',    'AY2526', 'ASF2526')
) AS v(Code, PeriodId, FundingTypeCode, FundingPeriodCode, FSPGroupCode)
WHERE NOT EXISTS (
    SELECT 1 FROM [FundingAllocation].[AllocationFundingStreamConfig] a
    WHERE a.AllocationFundingStreamCode = v.Code AND a.AllocationPeriodId = v.PeriodId);

INSERT INTO [FundingAllocation].[AllocationLineConfig]
    ([FundingStreamCode], [PeriodId], [FundingLineCode], [ProviderCategory], [FspCode], [DeliverableCode])
SELECT v.StreamCode, v.PeriodId, v.LineCode, v.ProviderCategory, v.FspCode, v.DeliverableCode
FROM (VALUES
    ('ASFC', 'AY-2526', 'ASFC-001', 'DEFAULT', 'ASF2023-FCFJ2526', 2),
    ('ASFC', 'AY-2526', 'ASFC-002', 'DEFAULT', 'ASF2023-FCFJ2526', 5),
    ('ASFC', 'AY-2526', 'ASFC-003', 'DEFAULT', 'ASF2023-AS2526',   4),
    ('ASFC', 'AY-2526', 'ASFC-004', 'DEFAULT', 'ASF2023-AS2526',   5),
    ('ASFG', 'AY-2526', 'ASFG-001', 'DEFAULT', 'ASFC-ASCL2526',    2),
    ('ASFG', 'AY-2526', 'ASFG-002', 'DEFAULT', 'ASFC-ASCL2526',    5),
    ('ASFG', 'AY-2526', 'ASFG-003', 'DEFAULT', 'ASFC-ASCL2526',    12),
    ('ASFG', 'AY-2526', 'ASFG-004', 'DEFAULT', 'ASFC-FCFJ2526',    2)
) AS v(StreamCode, PeriodId, LineCode, ProviderCategory, FspCode, DeliverableCode)
WHERE NOT EXISTS (
    SELECT 1 FROM [FundingAllocation].[AllocationLineConfig] l
    WHERE l.FundingStreamCode = v.StreamCode AND l.PeriodId = v.PeriodId
      AND l.FundingLineCode = v.LineCode AND l.ProviderCategory = v.ProviderCategory);

COMMIT TRANSACTION;";

        public static void EnsureAsfAllocationPeriod2526Exists()
        {
            var connectionString = new AppConfiguration()["ConnectionStrings:AllocationDeliveryDBContext"];

            using (var connection = new SqlConnection(connectionString))
            using (var command = new SqlCommand(SeedSql, connection))
            {
                connection.Open();
                command.ExecuteNonQuery();
            }
        }
    }
}
