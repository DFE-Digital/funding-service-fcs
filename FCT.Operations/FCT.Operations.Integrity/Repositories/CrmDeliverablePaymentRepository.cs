namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using Microsoft.Xrm.Sdk.Query;
    using System.Data.SqlClient;
    using Dapper;
    using DTOs;
    using FCS.Worker.Common;
    using FCS.Worker.Common.Crm;
    using System.IO;
    using System.Reflection;


    public class CrmDeliverablePaymentRepository : ICrmDeliverablePaymentRepository
    {
        private const string SqlApprovedRowsFspName = @"SFA.FCT.Operations.Integrity.IntegrityCheckers.Sql.GetApprovedRowsByFsps.sql";
        private const string PeriodParameterFormat = "yyyyMM";
        private static readonly ConcurrentDictionary<OptionSetKey, int?> _optionSets = new ConcurrentDictionary<OptionSetKey, int?>();
        private readonly IFcsConfiguration _configuration;

        public CrmDeliverablePaymentRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="allocationNumber"></param>
        /// <param name="version"></param>
        /// <param name="deliverableCode"></param>
        /// <param name="period">This should be in the format 'yyyyMM'</param>
        /// <returns></returns>
        public IReadOnlyCollection<CrmDeliverablePaymentData> GetByAllocationVersionDeliverableCodeAndVersion(
            string allocationNumber,
            int version,
            int deliverableCode,
            string period)
        {
            CheckArgument(() => IsPeriodInCorrectFormat(period), $"The period parameter must be '{PeriodParameterFormat}' not {period}");
            List<CrmDeliverablePaymentData> crmDeliverablePaymentDataList = new List<CrmDeliverablePaymentData>();
            EntityCollection entityCollection = GetPaymentScheduleDeliverablePayments(allocationNumber, version, deliverableCode, period);
            if (entityCollection != null)
            {
                foreach (var entity in entityCollection.Entities)
                {
                    CrmDeliverablePaymentData crmDeliverablePaymentData = new CrmDeliverablePaymentData()
                    {
                        ActualValue = GetNullableColumnValue<decimal>(entity, "p.sfa_actualvalue") ?? 0,
                        ActualVolume = GetNullableColumnValue<int>(entity, "p.sfa_actualvolume") ?? 0,
                        PlannedValue = GetNullableColumnValue<decimal>(entity, "p.sfa_plannedvalue") ?? 0,
                        PlannedVolume = GetNullableColumnValue<int>(entity, "p.sfa_plannedvolume") ?? 0,
                        BalancingPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_balancingpaymentamount"),
                        ReconciliationPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_reconciliationpaymentamount"),
                        CappingPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_cappedpaymentamount"),
                        NetPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_netpaymentamount"),
                        ProfilePaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_profilepaymentamount")
                    };

                    crmDeliverablePaymentDataList.Add(crmDeliverablePaymentData);
                }
            }

            return crmDeliverablePaymentDataList;
        }

        public IReadOnlyCollection<CrmDeliverablePaymentData> GetByAllocationNumberAndVersion(string allocationNumber, int version)
        {
            var connectionString = _configuration["ConnectionStrings:CrmDatabaseConnectionString"];
            var thirtyMinutesInSeconds = 30 * 60;

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<CrmDeliverablePaymentData>(
                        "dbo.sp_GetByAllocationNumberAndVersion",
                   new { allocationNumber, contractVersionNumber = version, contractStatus = (int)sfa_contractstatus.Approved },
                        commandTimeout: thirtyMinutesInSeconds
                        ).ToList();
            }
        }

        public IReadOnlyCollection<CrmDeliverablePaymentData> GetApprovedRowsByFsps(IReadOnlyCollection<string> activeFsps)
        {
            var connectionString = _configuration["ConnectionStrings:CrmDatabaseConnectionString"];
            var oneHourInSeconds = 60 * 60;

            using (var connection = new SqlConnection(connectionString))
            {
               return connection.Query<CrmDeliverablePaymentData>(
                        sql: GetSqlScriptFromResource(SqlApprovedRowsFspName),
                   new { activeFsps, contractStatus = (int)sfa_contractstatus.Approved },
                        commandTimeout: oneHourInSeconds
                        ).ToList();
            }
        }

        private static bool IsPeriodInCorrectFormat(string period)
        {
            bool isCorrectFormat = false;
            try
            {
                DateTime.ParseExact(period, PeriodParameterFormat, new System.Globalization.CultureInfo("en-GB"));
                isCorrectFormat = true;
            }
            catch (Exception)
            {
            }

            return isCorrectFormat;
        }

        private static EntityCollection GetPaymentScheduleDeliverablePayments(string allocationNumber, int version, int deliverableCode, string period)
        {
            QueryExpression queryExpression = CreateQueryExpressionForPaymentScheduleDeliverablePayment(allocationNumber, version, deliverableCode, period);
            return ExecuteQuery(queryExpression);
        }

        private static EntityCollection ExecuteQuery(QueryExpression query)
        {
            EntityCollection entityCollection = null;
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest();
            rmr.Query = query;

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest();
            emr.Requests = new OrganizationRequestCollection();
            emr.Requests.Add(rmr);
            emr.Settings = new ExecuteMultipleSettings();
            emr.Settings.ReturnResponses = true;

            ExecuteMultipleResponse xmr = (ExecuteMultipleResponse)CrmConnectionFactory.GetOrganizationService().Execute(emr);

            foreach (var response in xmr.Responses)
            {
                if (response.Response != null)
                {
                    foreach (var result in response.Response.Results)
                    {
                        entityCollection = result.Value as EntityCollection;
                    }
                }
            }

            return entityCollection;
        }

        private static QueryExpression CreateQueryExpressionForPaymentScheduleDeliverablePayment(string allocationNumber, int version, int deliverableCode, string period)
        {
            string periodDate;
            const string approvedStatus = "Approved";
            const string replacedStatus = "Replaced";

            DateTime dt = DateTime.ParseExact(period, PeriodParameterFormat, new System.Globalization.CultureInfo("en-GB"));
            periodDate = dt.ToString("MMM-yy");

            // first get the option set id for the status
            int? approvedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), approvedStatus);
            int? replacedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), replacedStatus);

            List<object> statuses = new List<object>();
            statuses.Add(approvedStatusId.Value);
            statuses.Add(replacedStatusId.Value);


            if (approvedStatusId.HasValue)
            {

                QueryExpression query = new QueryExpression
                {
                    EntityName = sfa_contract.EntityLogicalName,
                    ColumnSet = new ColumnSet("sfa_contractid"),
                    Criteria = new FilterExpression()
                };

                LinkEntity linkContractAllocations = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractid",
                    LinkToEntityName = sfa_contractallocation.EntityLogicalName,
                    LinkToAttributeName = "sfa_contractid",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("sfa_contractallocationnumber"),
                    EntityAlias = "a"
                };

                LinkEntity linkContractDeliverables = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractallocationid",
                    LinkToEntityName = sfa_contractdeliverable.EntityLogicalName,
                    LinkToAttributeName = "sfa_contractallocationid",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("sfa_deliverablecode"),
                    EntityAlias = "d"
                };

                LinkEntity linkContractDeliverablePeriod = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractdeliverableid",
                    LinkToEntityName = sfa_contractdeliverableperiod.EntityLogicalName,
                    LinkToAttributeName = "sfa_contractdeliverableid",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("sfa_actualvalue", "sfa_plannedvalue",
                    "sfa_balancingpaymentamount", "sfa_reconciliationpaymentamount",
                    "sfa_cappedpaymentamount", "sfa_netpaymentamount",
                    "sfa_profilepaymentamount", "modifiedon", "sfa_contractdeliverableperiodid"
                    ),
                    EntityAlias = "p"
                };

                linkContractDeliverables.LinkEntities.Add(linkContractDeliverablePeriod);
                linkContractAllocations.LinkEntities.Add(linkContractDeliverables);
                query.LinkEntities.Add(linkContractAllocations);

                query.Criteria.Conditions.Add(
               new ConditionExpression(
                   sfa_contract.EntityLogicalName,
                   "sfa_contractstatus",
                   ConditionOperator.In,
                   statuses.ToArray()));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        sfa_contract.EntityLogicalName,
                        "sfa_version",
                        ConditionOperator.In,
                        version));

                query.Criteria.Conditions.Add(
                   new ConditionExpression(
                       sfa_contractallocation.EntityLogicalName,
                       "sfa_contractallocationnumber",
                       ConditionOperator.In,
                       allocationNumber));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        sfa_contractdeliverable.EntityLogicalName,
                        "sfa_deliverablecode",
                        ConditionOperator.In,
                        deliverableCode.ToString()));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        sfa_contractdeliverableperiod.EntityLogicalName,
                        "sfa_periodname",
                        ConditionOperator.In,
                        periodDate));

                return query;
            }
            return null;
        }

        public static int? GetOptionsetValue(string optionsetName, string label)
        {
            return _optionSets.GetOrAdd(
                new OptionSetKey(optionsetName, label),
                delegate (OptionSetKey key)
                {
                    int? optionsetValue = null;
                    RetrieveOptionSetRequest retrieveOptionSetRequest =
                        new RetrieveOptionSetRequest
                        {
                            Name = key.OptionSetName
                        };

                    // Execute the request.
                    RetrieveOptionSetResponse retrieveOptionSetResponse =
                        (RetrieveOptionSetResponse)GetConnection().Execute(retrieveOptionSetRequest);

                    // Access the retrieved OptionSetMetadata.
                    OptionSetMetadata retrievedOptionSetMetadata =
                        (OptionSetMetadata)retrieveOptionSetResponse.OptionSetMetadata;

                    // Get the current options list for the retrieved attribute.
                    OptionMetadata[] optionList = retrievedOptionSetMetadata.Options.ToArray();
                    foreach (OptionMetadata optionMetadata in optionList)
                    {
                        if (optionMetadata.Label.LocalizedLabels.First().Label == key.OptionSetText)
                        {
                            optionsetValue = optionMetadata.Value;
                            break;
                        }
                    }

                    return optionsetValue;
                });
        }

        private static string GetSqlScriptFromResource(string sqlResourceName)
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(sqlResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }
        private static void CheckArgument(Func<bool> isArgumentValid, string failureMessage)
        {
            if (!isArgumentValid())
            {
                throw new ArgumentException(failureMessage);
            }
        }

        private static T? GetNullableColumnValue<T>(Entity entity, string columnName) where T : struct
        {
            return entity.Contains(columnName)
                ? (T?)((AliasedValue)(entity.Attributes[columnName])).Value
                : null;
        }

        private static DateTime? GetDateTimeColumnValue(Entity entity, string columnName)
        {
            return entity.Contains(columnName)
                ? ((DateTime?)(entity.Attributes[columnName]))
                : null;
        }

        public static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetOrganizationService();
        }
    }
}
