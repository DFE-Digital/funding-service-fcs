namespace PaymentsGateway.Common
{
    using System.Collections.Generic;

    public class PaymentFile
    {
        public string FileName { get; set; }

        public bool IsFileCreated { get; set; }

        public IEnumerable<string> Contents { get; set; }
    }
}