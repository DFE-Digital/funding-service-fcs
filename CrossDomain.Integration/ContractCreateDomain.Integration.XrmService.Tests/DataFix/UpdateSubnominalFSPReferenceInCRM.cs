using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using ContractCreateDomain.Integration.XrmService.Tests.IntegrationTests;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xrm.Sdk.Query;
using System.Threading.Tasks;
using System.Collections;
using Microsoft.Xrm.Sdk.Messages;

namespace ContractCreateDomain.Integration.XrmService.Tests.DataFix
{
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    [TestClass]
    public class UpdateSubnominalFSPReferenceInCRM : IntegrationTestBase
    {
        private const string CrmConnectionString = "<INSERT CRM CONNECTION STRING>";

        //private int recordsProcessed = 0;
        IDictionary allocationCache = new Dictionary<string, EntityReference>();
        IDictionary allocationProviderCache = new Dictionary<string, EntityReference>();

        [TestMethod, TestCategory("DataFix_R29")]
        public void ApplySubnominalFSPReferenceInCRM()
        {
            try
            {
                GetContractAllocationFSP(new OrganizationService(GetConnection()));

                IReadOnlyCollection<string> subCodes = GetSubnominalCodes();
                Parallel.ForEach(subCodes, new ParallelOptions { MaxDegreeOfParallelism = 12},
                    UpdateFSPReference);

                //System.Diagnostics.Trace.WriteLine("Total Record Count Processed: " + recordsProcessed);

            }
            catch (Exception e)
            {
                System.Diagnostics.Trace.WriteLine("error:" + e.Message);
                Assert.Fail();
            }

        }

        private IReadOnlyCollection<string> GetSubnominalCodes()
        {
            string subCodes =
                "2200030,2201000,2201060,2201065,2201071,2201072,2201300,2201350,2201430,2201850,2202080,2202800,2202850,2202993,2203000,2203001,2203002,2203006,2203007,2203020,2203021,2206020,2206025,2206029,2206036,2206037,2206041,2218120,2218300,2219100,2219110,2219120,2240100,2240110,2240120,2240130,2240140,2240150,2240160,2260010,2301000,2301075,2301500,2301560,2303000,2303075,2303300,2303400,2303800,2303900,2303975,2304100,2304175,2305310,2306100,2306175,2306430,2306431,2306600,2306800,2306816,2306850,2306860,2306865,2306871,2306872,2306900,2306960,2306971,2306972,2308500,2308560,2322060,2322400,2340100,2340110,2340120,2340130,2340140,2340150,2340160,2355800,2355816,2355860,2355865,2360010,2371010,2371075,2372010,2372016,2372030,2372045,2372060,2372065,2372075,2520500,2520900,2521300,2671111,2671112,2671114,2671211,2671212,2671214,2671311,2671312,2671314,2672121,2672122,2672221,2672222,2672321,2672322";

            return subCodes.Split(',').ToList();
        }

        #region  Function Calls
        private IOrganizationService GetConnection()
        {
            var xrmConnection =
               CrmConnection.Parse(CrmConnectionString);

            return new OrganizationService(xrmConnection);
        }


        private void UpdateFSPReference(string subnominalCode)
        {
            OrganizationService service = new OrganizationService(GetConnection());
            try
            {
                // Query using the paging cookie.
                // Define the paging attributes.
                // The number of records per page to retrieve.
                int queryCount = 1000;

                // Initialize the page number.
                int pageNumber = 1;

                QueryExpression query = new QueryExpression
                {
                    EntityName = "sfa_subnominalaggregation",
                    ColumnSet = new ColumnSet("sfa_subnominalaggregatekey", "sfa_name", "sfa_fundingstreamperiod")
                };
                query.Criteria.AddCondition("sfa_fundingstreamperiod", ConditionOperator.Null);
                query.Criteria.AddCondition("sfa_name", ConditionOperator.Equal, subnominalCode);

                // Assign the pageinfo properties to the query expression.
                query.PageInfo = new PagingInfo();
                query.PageInfo.Count = queryCount;
                query.PageInfo.PageNumber = pageNumber;

                // The current paging cookie. When retrieving the first page, 
                // pagingCookie should be null.
                query.PageInfo.PagingCookie = null;
                int count = 0;
                ExecuteMultipleRequest req = new ExecuteMultipleRequest();
                while (true)
                {
                    // Retrieve the page.
                    EntityCollection results = service.RetrieveMultiple(query);

                    if (results.Entities.Any())
                    {
                        //if (recordsProcessed == 0)
                            //System.Diagnostics.Trace.WriteLine("Results to loop! Processing, please wait to complete");

                        foreach (Entity targetEntity in results.Entities)
                        {
                            if (count == 0)
                            {
                                req = new ExecuteMultipleRequest();
                                req.Requests = new OrganizationRequestCollection();
                                req.Settings = new ExecuteMultipleSettings();
                                req.Settings.ContinueOnError = true;
                                req.Settings.ReturnResponses = true;

                            }
                            string subnominalKey = targetEntity.GetAttributeValue<string>("sfa_subnominalaggregatekey");
                            var allocRef = "";
                            EntityReference contractAllocationFSP = null;
                            EntityReference contractAllocationProvider = null;

                            if (subnominalKey != null)
                            {
                                allocRef = subnominalKey.Split('_', '_')[1];
                                if (allocationCache.Contains(allocRef))
                                {
                                    contractAllocationFSP = (EntityReference)allocationCache[allocRef];
                                    contractAllocationProvider = (EntityReference)allocationProviderCache[allocRef];
                                }
                            }

                            if ((contractAllocationFSP != null))
                            {
                                //recordsProcessed++;
                                count++;
                                Entity subnominalToUpdate = new Entity("sfa_subnominalaggregation");
                                subnominalToUpdate.Id = targetEntity.Id;
                                subnominalToUpdate.Attributes["sfa_fundingstreamperiod"] = contractAllocationFSP;
                                subnominalToUpdate.Attributes["sfa_provider"] = contractAllocationProvider;
                                UpdateRequest updateRequest = new UpdateRequest { Target = subnominalToUpdate };
                                req.Requests.Add(updateRequest);
                            }
                            else
                            {
                                System.Diagnostics.Trace.WriteLine("NOT FOUND:" + allocRef);
                            }

                            if (count == 998)
                            {
                                var res = service.Execute(req) as ExecuteMultipleResponse; //Execute the collection of requests
                                count = 0;
                            }
                        }
                    }

                    // Check for more records, if it returns true.
                    if (results.MoreRecords)
                    {
                        // Increment the page number to retrieve the next page.
                        query.PageInfo.PageNumber++;

                        // Set the paging cookie to the paging cookie returned from current results.
                        query.PageInfo.PagingCookie = results.PagingCookie;
                    }
                    else
                    {
                        if (count > 0) { var res = service.Execute(req) as ExecuteMultipleResponse; }
                        // If no more records are in the result nodes, exit the loop.
                        break;
                    }
                }

                System.Diagnostics.Trace.WriteLine("***Looping is Complete***");

            }
            catch (System.Exception ex)
            {
                System.Diagnostics.Trace.WriteLine("Error:" + ex.Message);
            }

        }

        private void GetContractAllocationFSP(OrganizationService service)
        {

            System.Diagnostics.Trace.WriteLine("populating cache");

            try
            {
                // Query using the paging cookie.
                // Define the paging attributes.
                // The number of records per page to retrieve.
                int queryCount = 1000;

                // Initialize the page number.
                int pageNumber = 1;

                QueryExpression query = new QueryExpression
                {
                    EntityName = "sfa_contractallocation",
                    ColumnSet = new ColumnSet("sfa_contractallocationnumber", "sfa_fundingstreamperiodid")
                };
                query.Criteria.AddCondition("sfa_fundingstreamperiodid", ConditionOperator.NotNull);

                query.LinkEntities.Add(new LinkEntity("sfa_contractallocation", "sfa_contract", "sfa_contractid", "sfa_contractid", JoinOperator.Inner));
                query.LinkEntities[0].Columns.AddColumns("sfa_providername");
                query.LinkEntities[0].EntityAlias = "associatedcontract";

                // Assign the pageinfo properties to the query expression.
                query.PageInfo = new PagingInfo();
                query.PageInfo.Count = queryCount;
                query.PageInfo.PageNumber = pageNumber;

                // The current paging cookie. When retrieving the first page, 
                // pagingCookie should be null.
                query.PageInfo.PagingCookie = null;

                while (true)
                {
                    // Retrieve the page.
                    EntityCollection results = service.RetrieveMultiple(query);

                    if (results.Entities.Any())
                    {
                        foreach (Entity targetEntity in results.Entities)
                        {
                            string allocationNumber = targetEntity.GetAttributeValue<string>("sfa_contractallocationnumber");
                            EntityReference allocationFSP = targetEntity.GetAttributeValue<EntityReference>("sfa_fundingstreamperiodid");
                            if ((allocationNumber != null) && (!allocationCache.Contains(allocationNumber)))
                            {
                                allocationCache.Add(allocationNumber, allocationFSP);
                                //provider
                                EntityReference allocationProvider = (EntityReference)((AliasedValue)targetEntity["associatedcontract.sfa_providername"]).Value;
                                if (allocationProvider != null)
                                    allocationProviderCache.Add(allocationNumber, allocationProvider);
                            }

                        }
                    }

                    // Check for more records, if it returns true.
                    if (results.MoreRecords)
                    {
                        // Increment the page number to retrieve the next page.
                        query.PageInfo.PageNumber++;

                        // Set the paging cookie to the paging cookie returned from current results.
                        query.PageInfo.PagingCookie = results.PagingCookie;
                    }
                    else
                    {
                        // If no more records are in the result nodes, exit the loop.
                        break;
                    }
                }

            }
            catch (System.Exception ex)
            {
                System.Diagnostics.Trace.WriteLine("Error:" + ex.Message);
            }

        }

        #endregion
    }
}
