namespace PaymentsGateway.Common
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using Framework;

    /// <summary>
    /// Serialize and Deserialize Lists of any object type to CSV.
    /// </summary>
    public class CsvSerializer : ICsvSerializer
    {
        public ILogger Logger { get; set; }

        public IEnumerable<string> ToCsv<T>(string separator, IEnumerable<T> objectlist, bool hasHeader)
        {
            var properties = typeof(T).GetProperties();

            if (hasHeader)
            {
                yield return string.Join(separator, properties.Select(p => p.Name).ToArray());
            }

            foreach (var o in objectlist)
            {
                yield return string.Join(separator, properties.Select(p => (p.GetValue(o, null) ?? string.Empty).ToString()).ToArray());
            }
        }

        public byte[] ToBytes<T>(string separator, IEnumerable<T> objectlist)
        {
            var csvData = ToCsv(separator, objectlist, false);

            var dataAsBytes = csvData.ToArray().SelectMany(s => Encoding.ASCII.GetBytes(s + Environment.NewLine)).ToArray();

            return dataAsBytes;
        }
    }
}
