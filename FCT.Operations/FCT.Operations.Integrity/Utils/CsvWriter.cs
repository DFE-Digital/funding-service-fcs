namespace SFA.FCT.Operations.Integrity.Utils
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;

    public class CsvWriter<T> where T : class
    {
        private readonly string _fileName;
        private readonly List<string> _fileLines = new List<string>();
        private PropertyInfo[] _typePropertyInfos = null;

        public CsvWriter(string fileName)
        {
            _fileName = fileName;
        }

        public CsvWriter()
        {
        }

        public string CreateCsv(IEnumerable<T> items)
        {
            CreateFileLines(items);

            StringWriter writer = new StringWriter();

            _fileLines.ForEach(writer.WriteLine);

            return writer.ToString();
        }

        public void SaveItems(IEnumerable<T> items)
        {
            CreateFileLines(items);

            if (_fileName != null)
            {
                // now output the file
                CreateFile();
            }
        }

        private void CreateFileLines(IEnumerable<T> items)
        {
            _fileLines.Add(GetHeaderFileLine());

            // now add the data lines
            _fileLines.AddRange(GetItemsInCsvFormat(items));
        }

        private IList<string> GetItemsInCsvFormat(IEnumerable<T> items)
        {
            return items.Select(i => string.Join(",", PropertyInfos.Select(pi => pi.GetValue(i)))).ToList();
        }

        private PropertyInfo[] PropertyInfos
        {
            get
            {
                if (_typePropertyInfos == null)
                {
                    _typePropertyInfos = typeof (T).GetProperties()
                                                    .Where(pi => !IsIgnoreColumnProperty(pi)).ToArray();

                    _typePropertyInfos = _typePropertyInfos.OrderBy(
                        pi => (GetOrderAttributeForProperty(pi)).Order).ToArray();
                }

                return _typePropertyInfos;
            }
        }

        private OrderAttribute GetOrderAttributeForProperty(PropertyInfo propertyInfo)
        {
            OrderAttribute order = propertyInfo.GetCustomAttribute<OrderAttribute>();

            return order ?? new OrderAttribute(1);
        }

        private bool IsIgnoreColumnProperty(PropertyInfo propertyInfo)
        {
            IgnoreColumnWhenGeneratingCsvAttribute ignoreColumn = propertyInfo.GetCustomAttribute<IgnoreColumnWhenGeneratingCsvAttribute>();

            return ignoreColumn != null;
        }

        private string GetHeaderFileLine()
        {
            return string.Join(",", PropertyInfos.Select(pi => pi.Name));
        }

        private void CreateFile()
        {
            using (StreamWriter writer = new StreamWriter(_fileName))
            {
                _fileLines.ForEach(writer.WriteLine);
            }
        }
    }
}

