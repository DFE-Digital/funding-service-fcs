namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

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

        [Key]
        public int Id { get; private set; }

        [Required, MaxLength(30)]
        public string Version { get; private set; }

        [Required, MaxLength(16)]
        public byte[] Checksum { get; private set; }
    }
}