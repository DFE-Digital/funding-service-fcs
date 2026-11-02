namespace FCT.Operations.DataStore.Model
{
    public class DeployedConfigVersion
    {
        private DeployedConfigVersion()
        {
        }

        public DeployedConfigVersion(string version, byte[] checksum)
        {
            Version = version;
            Checksum = checksum;
        }

        public int Id { get; private set; }
        public string Version { get; private set; }
        public byte[] Checksum { get; private set; }
    }
}
