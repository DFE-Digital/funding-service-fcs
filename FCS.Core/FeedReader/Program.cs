namespace FeedReader;

using CommandLine;
using FundingAllocation.Services;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

internal class Program
{
    private const string OutputDirectory = "cfs_feed";
    public static async Task Main(string[] args)
    {
        var parser = await Parser.Default.ParseArguments<Options>(args)
            .WithParsedAsync<Options>(async o =>
            {
                if (o.Environment == Environment.NotSet)
                {
                    o.Environment = Environment.Prod;
                    Console.WriteLine($"No environment option chosen, running against: {o.Environment}");
                }
                else
                {
                    Console.WriteLine($"Running against environment: {o.Environment}");
                }
                
                await ReadFeedAndStoreOnDisk(o.Environment);
            });
        parser.WithNotParsed(errors =>
        {
            Console.WriteLine($"failed to parse environment, options are: {string.Join(", ", Enum.GetNames(typeof(Environment)))}");
        });
    }

    private static async Task ReadFeedAndStoreOnDisk(Environment environment)
    {
        var config = AppConfiguration.Configuration();
        SetupEnvironment(environment, config);
        FundingNotificationApi fundingNotificationApi = new FundingNotificationApi(config);
        Console.WriteLine("Getting latest page");

        var latestPage = await fundingNotificationApi.GetLatestPageData();
        System.IO.Directory.CreateDirectory(OutputDirectory);

        await WritePageToDisk(latestPage.AtomItems, "Lastest.json");
        var pageTasks = Enumerable.Range(1, latestPage.PageNumber - 1).ToList().Select(GetAndWritePage);

        await Task.WhenAll(pageTasks);
    }

    private static void SetupEnvironment(Environment environment, IConfigurationRoot configuration)
    {
        configuration["CFS:RootUrl"] = configuration[$"CFS:{environment}:RootUrl"];
        configuration["CFS:ClientId"] = configuration[$"CFS:{environment}:ClientId"];
        configuration["CFS:ClientSecret"] = configuration[$"CFS:{environment}:ClientSecret"];
        configuration["CFS:Scope"] = configuration[$"CFS:{environment}:Scope"];
    }
    private static async Task GetAndWritePage(int pageNumber)
    {
        Console.WriteLine($"Getting page: {pageNumber}");
        FundingNotificationApi fundingNotificationApi = new FundingNotificationApi(AppConfiguration.Configuration());
        var atomItems = await fundingNotificationApi.GetPage(pageNumber);
        Console.WriteLine($"Got page: {pageNumber}, writing to disk");
        
        await WritePageToDisk(atomItems, $"Page{pageNumber}.json");
    }

    private static async Task WritePageToDisk(IReadOnlyCollection<AtomItem> atomItems, string pageName)
    {
        var json = JsonConvert.SerializeObject(atomItems);
        await File.WriteAllTextAsync($"{OutputDirectory}/{pageName}", json);
    }
}