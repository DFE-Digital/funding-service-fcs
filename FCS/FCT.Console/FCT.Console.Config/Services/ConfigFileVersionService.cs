namespace FCT.Console.Config.Services
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Security.Cryptography;
    using System.Text;
    using Dtos;
    using Newtonsoft.Json.Linq;
    using Repositories;
    using UnitTests.Common;

    public static class ConfigFileVersionService
    {
        public static bool HasConfigChanged()
        {
            var latestConfigInfo = DeployedConfigVersionRepository.GetLatestDeployedConfigVersionInfo();

            if (latestConfigInfo != null)
            {
                var currentJsonHash = GetMd5Hash(GetJsonFromFile().ToString());

                var hasConfigChanged = latestConfigInfo.Checksum.SequenceEqual(currentJsonHash) == false;

                Console.WriteLine($"We have checked the config, hasConfigChanged: {hasConfigChanged}");

                return hasConfigChanged;
            }

            return true;
        }

        public static void WriteConfigInfoIntoTable()
        {
            var json = GetJsonFromFile();
            string version = json["Version History"].First()["LatestVersion"].ToString();
            var checkSum = GetMd5Hash(json.ToString());

            DeployedConfigVersionRepository.AddDeployedConfigVersion(new DeployedConfigVersionInfo(version, checkSum));

            Console.WriteLine($"We have added ConfigInfo row to table for config version '{version}'");
        }

        private static JObject GetJsonFromFile()
        {
            var assembly = Assembly.GetExecutingAssembly();
            var namespaceName = assembly.FullName.Split(',').First();
            using (var resource = new TestResource(namespaceName, @"Resources.Config.json"))
            {
                return JObject.Parse(new StreamReader(resource.Stream).ReadToEnd());
            }
        }

        private static byte[] GetMd5Hash(string input)
        {
            using (var provider = new MD5CryptoServiceProvider())
            {
                var inputBytes = Encoding.Default.GetBytes(input);

                return provider.ComputeHash(inputBytes);
            }
        }
    }
}
