using System;
using System.Configuration;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using Microsoft.Xrm.Client.Services;

namespace SFA.CRM.MergeFlagBulkUpdate
{
    class Program
    {
        static void Main(string[] args)
        {

            Console.Title = "Bulk Update for the Skip Merge Flag on Contract";
            //Establish the connection to CRM
            CrmConnection connection = new CrmConnection("Crm");
            var service = new OrganizationService(connection);

            //User Notification
            Console.WriteLine("**The Program updates the Skip Merge Flag against all existing Contracts based on their funding type**\n");
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
                    EntityName = "sfa_contract",
                    ColumnSet = new ColumnSet("sfa_number", "sfa_ukprn", "sfa_documentationrequired", "sfa_fundingtype", "sfa_skipdocumentmerge")
                };

                query.Criteria.AddCondition("sfa_number", ConditionOperator.NotNull);
                //query.Criteria.AddCondition("sfa_number", ConditionOperator.Equal, "EMP1-2253");
                query.Criteria.AddCondition("sfa_fundingtype", ConditionOperator.NotNull);
                query.Criteria.AddCondition("sfa_hierarchytype", ConditionOperator.Equal, 229660000);
                //query.Criteria.AddCondition("createdon", ConditionOperator.LessThan, DateTime.Today.AddDays(-9));

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
                    if (results.Entities != null)
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
                            var sfaMerge = targetEntity.GetAttributeValue<bool>("sfa_skipdocumentmerge");
                            var sfaDocRequired = targetEntity.GetAttributeValue<bool>("sfa_documentationrequired");
                            var sfaFundingType = targetEntity.GetAttributeValue<EntityReference>("sfa_fundingtype").Name;

                            //Console.WriteLine("number:ukprn " + targetEntity["sfa_number"] + ":" + targetEntity["sfa_ukprn"] + ":" + sfaFundingType + ":" + sfaDocRequired + ":" + sfaMerge);

                            if (sfaFundingType.Equals("Employer Ownership Fund") || sfaFundingType.Equals("Employer Ownership Pilot") || sfaFundingType.Equals("Apprenticeship Levy"))
                            {
                                targetEntity.Attributes["sfa_skipdocumentmerge"] = true;
                            }
                            else
                            {
                                targetEntity.Attributes["sfa_skipdocumentmerge"] = false;
                            }

                            service.Update(targetEntity);

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
    }
}
