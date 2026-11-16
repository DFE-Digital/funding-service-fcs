namespace SFA.FCT.ContractRequestDomain.DataStore.Model
{
    using System.Collections.Concurrent;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FileWatcherLockResource
    {
        public const string LockKey = "Lock";

        [Key]
        [Column(Order = 0)]
        [MaxLength(100)]
        public string Identifier { get; set; } = LockKey;
    }
}
