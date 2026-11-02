namespace FCT.Console.Config.Dtos
{
    public class DeployedConfigVersionInfo
    {
        public DeployedConfigVersionInfo()
        {
        }

        public DeployedConfigVersionInfo(string version, byte[] checksum)
        {
            Version = version;
            Checksum = checksum;
        }

        public string Version { get; set; }

        public byte[] Checksum { get; set; }
    }
}