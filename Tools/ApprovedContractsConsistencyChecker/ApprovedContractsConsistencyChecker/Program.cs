using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using ApprovedContractsConsistencyChecker.Readers;
using Castle.Windsor;
using Microsoft.Xrm.Sdk;
using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
using SFA.FCT.ContractManagementService.Test.IoC;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using SFA.FCT.Framework.Logging;
using SFA.FCT.Framework.Logging.Interfaces;


namespace ApprovedContractsConsistencyChecker
{
    class Program
    {
        private static readonly List<CheckedContract> CheckedContracts = new List<CheckedContract>();
        private static readonly List<CheckedContract> ApprovedContractsPublishedInFeed = new List<CheckedContract>();

        #region Injected Dependencies
        private static IContractsManager ContractsManager { get; set; }
        private static IWindsorContainer Container { get; set; }
        private static ILogger Logger { get; set; }
        #endregion

        static void Main(string[] args)
        {
            SetupIoC();

            Console.Out.WriteLine("Getting approved contracts from Crm...");
            var approvedContracts = GetApprovedContractsFromCrm();
            var numberOfContracts = approvedContracts.Count();

            Console.Out.WriteLine("{0} approved contracts retrieved.", numberOfContracts);

            CheckContractsAgainstAtomFeed(approvedContracts);
            Console.Out.WriteLine("Comparing retrieved contracts against atom feed...");

            if (CheckedContracts.Count(x => x.IsInAtomFeed == false) == 0)
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.Out.WriteLine("Success!");
                Console.Out.WriteLine("All retrieved approved contracts are consistent with the atom feed.");
                Console.ResetColor();
                Console.ReadLine();
            }
            else
            {
                WriteOutputToFile();
                Console.ForegroundColor = ConsoleColor.Red;
                Console.Out.WriteLine("Error!");
                Console.Out.WriteLine("Some approved contracts were not found in the atom feed.");
                Console.Out.WriteLine("Please review the output file for details.");
                Console.ReadLine();                
            }
        }

        private static void CheckContractsAgainstAtomFeed(IEnumerable<ContractSummary> approvedContracts)
        {
            var reader = new ApprovedContractFeedReader();
            reader.Read(ReadFeedToLastPage);
            CheckContracts(approvedContracts);
        }

        private static List<ContractSummary> GetApprovedContractsFromCrm()
        {
            return ContractsManager.GetApprovedContracts(DateTime.MinValue).ToList();
        }

        private static void CheckContracts(IEnumerable<ContractSummary> crmContracts)
        {
            try
            {
                var feedContracts = ApprovedContractsPublishedInFeed;
                foreach (var crmContract in crmContracts)
                {
                    var result = feedContracts.Any(x => x.ContractNumber == crmContract.ContractNumber && x.ContractVersion == crmContract.ContractVersionNumber);
                    var checkedContract = new CheckedContract
                    {
                        ContractNumber = crmContract.ContractNumber,
                        ContractVersion = crmContract.ContractVersionNumber
                    };
                    if (result)
                    {
                        checkedContract.IsInAtomFeed = true;
                    }
                    CheckedContracts.Add(checkedContract);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(001, "An error occurred while comparing Approved Contracts retrieved from CRM against the Atom Feed. Message: {0}", ex.Message);
            }
        }

        private static void ReadFeedToLastPage(string feed)
        {
            try
            {
                var doc = XDocument.Parse(feed);
                if (doc.Root != null)
                {
                    var attribute = doc.Root.Attributes().FirstOrDefault(a => a.IsNamespaceDeclaration);
                    if (attribute != null)
                    {
                        var xmlNamespace = attribute.Value;
                        XNamespace ns = xmlNamespace;
                        var entrySummaries = doc.Descendants(ns + "entry").Elements(ns + "summary").Select(x => x.Value).ToList();

                        foreach (var entrySummary in entrySummaries)
                        {
                            var summaryArray = entrySummary.Split(',');
                            var contractNumber = summaryArray[1].Split(':')[1].Trim();
                            var contractVersion = summaryArray[2].Split(':')[1].Trim().Trim('}');
                            var feedContract = new CheckedContract
                            {
                                ContractNumber = contractNumber,
                                ContractVersion = Convert.ToInt32(contractVersion)
                            };
                            ApprovedContractsPublishedInFeed.Add(feedContract);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                Logger.LogError(002, "An error occurred while reading the Atom Feed. Message: {0}", ex.Message);
            }
        }

        private static void WriteOutputToFile()
        {
            try
            {
                var file = new FileInfo(string.Format("Approved Contracts not in Atom Feed {0}.txt", DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss")));
                foreach (var checkedContract in CheckedContracts)
                {
                    if (checkedContract.IsInAtomFeed == false)
                    {
                        File.AppendAllText(file.FullName, checkedContract.ToString() + Environment.NewLine);
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(003, "An error occurred while writing the output to file. Message: {0}", ex.Message);
            }
        }

        private static void SetupIoC()
        {
            Container = new WindsorContainer().Install(new WindsorInstaller());
            ContractsManager = Container.Resolve<IContractsManager>();
            Logger = Container.Resolve<ILogger>();
        }
    }
}
