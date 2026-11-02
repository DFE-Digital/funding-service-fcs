using System;
using System.Configuration;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk.Client;
using System.Linq;
using Polly;

namespace SFA.CRM.PlannedVolumeUpdate
{
    class Program
    {
        /// <summary>
        /// Tool to Bulk update the Total Planned Volume against the deliverables
        /// associated to Contracts with Funding Type as ESIF
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {

            Console.Title = "Bulk Update for the Total Planned Volume on Deliverable record";
            //Establish the connection to CRM
            CrmConnection connection = new CrmConnection("Crm");
            var service = new OrganizationService(connection);
            CrmOrganizationServiceContext xrmContext = new CrmOrganizationServiceContext(service);
            //selected Funding Type
            const string selectedFunding = "European Social Fund 2014-20";

            //User Notification
            Console.WriteLine("**The Program updates the Total Planned Volume against all existing Deliverables associated to Contracts with the ESF Funding Type**\n");
            Console.WriteLine("Environment: "+ ConfigurationManager.AppSettings["environment"]);
            Console.WriteLine("[Press any Key to Start]\n");
            Console.ReadKey(true);

            try
            {
                // Query using the paging cookie.
                // Define the paging attributes.
                // The number of records per page to retrieve.
                int queryCount = 1000;

                // Initialize the page number.
                int pageNumber = 1;

                // Initialize the number of records.
                int count = 0;

                QueryExpression query = new QueryExpression
                {
                    EntityName = "sfa_contractdeliverable",
                    ColumnSet = new ColumnSet("sfa_deliverablename")
                };


                LinkEntity contract = new LinkEntity
                {
                    LinkFromEntityName = "sfa_contractdeliverable",
                    LinkToEntityName = "sfa_contract",
                    LinkFromAttributeName = "sfa_contractid",
                    LinkToAttributeName = "sfa_contractid"
                };

                Guid ESIF = xrmContext.CreateQuery("sfa_fundingtype").Where(c => (String)c["sfa_name"] == selectedFunding).Single().ToEntityReference().Id;

                contract.LinkCriteria.AddCondition("sfa_fundingtype", ConditionOperator.Equal, ESIF); 
                query.LinkEntities.Add(contract);

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
                        if (count == 0)
                            Console.WriteLine("Results to loop! Processing, please wait to complete");

                        foreach (Entity targetEntity in results.Entities)
                        {
                            //Console.WriteLine("Inside Loop");
                            if ((count % 10) == 0)
                            {
                                Console.Write(".");
                            }
                            count++;
                            var sfaDeliverableName = targetEntity.GetAttributeValue<string>("sfa_deliverablename");

                            int TotalPlannedVolume = GetDeliverableTotalPlannedVolume(xrmContext,targetEntity.ToEntityReference());                           
                            targetEntity.Attributes["sfa_plannedvolume"] = TotalPlannedVolume;

                            //write the update                            
                            const int numRetries = 3;
                            const int numSecondsToWaitBetweenRetries = 2;
                            Action actionToRetry = () =>
                            {
                                service.Update(targetEntity);
                            };

                            //wrapper around update to retry with delay
                            Policy.Handle<Exception>(fex => fex.Message.Contains("Generic SQL error"))
                           .WaitAndRetry(numRetries, retry => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                           .Execute(actionToRetry);

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

                Console.WriteLine("\n\n***Process is Complete***");
                Console.WriteLine("Records Processed: " + count);
                Console.WriteLine("[Press any Key to Exit]\n");
                Console.ReadKey(true);

            } catch(System.Exception ex)
            {
                Console.WriteLine("The application terminated with an error.");
                Console.WriteLine(ex.Message);
                Console.ReadKey(true);
            }
        }


        /// <summary>
        /// Get the aggregated Total Planned Volume from the Deliverable Periods.
        /// </summary>
        /// <param name="xrmContext"></param>
        /// <param name="deliverable"></param>
        /// <returns>Total Planned Volume for Deliverable</returns>
        private static int GetDeliverableTotalPlannedVolume(OrganizationServiceContext xrmContext,EntityReference deliverable)
        {

            int totalPlannedVolume = 0;

            //Kept it simple and query only one level of deliverable since here the funding type is ESIF only
            var childDeliverablePeriodsValues = xrmContext.CreateQuery("sfa_contractdeliverableperiod")
                .Where(c => ((EntityReference)c["sfa_contractdeliverableid"]).Id == deliverable.Id)
                .Where(c => (c["sfa_plannedvolume"] != null))
                .Select(c => c.GetAttributeValue<int>("sfa_plannedvolume")).ToList();

            if (childDeliverablePeriodsValues.Any())
            {
                totalPlannedVolume = childDeliverablePeriodsValues.Sum();
            }

            return totalPlannedVolume;
        }

    }
}
