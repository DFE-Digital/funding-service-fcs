namespace PaymentsGateway.Common
{
    using System.Collections.Generic;
    using Framework;

    public interface ICsvSerializer
    {
        ILogger Logger { get; set; }

        IEnumerable<string> ToCsv<T>(string separator, IEnumerable<T> objectlist, bool hasHeader);
        
        byte[] ToBytes<T>(string separator, IEnumerable<T> objectlist);
    }
}
