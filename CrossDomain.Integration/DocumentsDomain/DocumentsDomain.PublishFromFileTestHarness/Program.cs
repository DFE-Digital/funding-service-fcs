using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Threading;
using SFA.FCT.DocumentsDomain.Common.Commands;

namespace DocumentsDomain.PublishFromFileTestHarness
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    class Program
    {
        private ISendOnlyBus bus = null; 
        private static void Main(string[] args)
        {
            new Program().Start();
        }

        private void Start()
        {

            BusConfiguration cfg = new BusConfiguration();
            cfg.UseTransport<MsmqTransport>();
            cfg.UsePersistence<InMemoryPersistence>();
            cfg.DiscardFailedMessagesInsteadOfSendingToErrorQueue();
            cfg.Conventions()
                .DefiningEventsAs(t => null != t.Namespace && t.Namespace == "SFA.FCT.CrossDomain.Integration.Events")
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace == "SFA.FCT.DocumentsDomain.Common.Commands");

            string path = ConfigurationManager.AppSettings["PublishFromFileTestHarness.DirectoryToWatch"];
            DirectoryInfo directory = new DirectoryInfo(path);
            if (!directory.Exists)
            {
                directory.Create();
            }
            else
            {
                //(directory.GetFiles("*.xml")).ToList().ForEach(f => f.Delete());
            }

            using (FileSystemWatcher watcher = new FileSystemWatcher(path, "*.xml"))
            {
                watcher.Renamed += _watcher_Renamed;
                watcher.Created += _watcher_Created;

                bus = Bus.CreateSendOnly(cfg);
                watcher.EnableRaisingEvents = true;

                Console.WriteLine("Press enter to exit this test harness.");
                Console.ReadLine();
            }

        }

        private void _watcher_Created(object sender, FileSystemEventArgs e)
        {
            HandleNewFile(e.FullPath);
        }

        private void _watcher_Renamed(object sender, RenamedEventArgs e)
        {
            HandleNewFile(e.FullPath);
        }

        private void HandleNewFile(string fullPath)
        {

            try
            {
                Console.WriteLine("Processing {0}", fullPath);
                contract corporateContract;

                int tryCount = 0;
                while (true)
                {
                    try
                    {
                        using (Stream inputStream = new FileStream(fullPath, FileMode.Open, FileAccess.Read))
                        {
                            System.Xml.Serialization.XmlSerializer xs = new System.Xml.Serialization.XmlSerializer(typeof (contract));
                            corporateContract = xs.Deserialize(inputStream) as contract;
                            break;
                        }
                    }
                    catch (Exception)
                    {
                        tryCount++;
                        if (tryCount >= 3)
                        {
                            throw;
                        }
                        Thread.Sleep(1000);
                    }
                }

                Console.WriteLine("Sending {0}", fullPath);
                bus.Send<DocumentGenerationCommand>(c => c.CorporateContract = corporateContract);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception sending the contract for {0}: {1}", fullPath, ex);
            }
        }
    }
}
