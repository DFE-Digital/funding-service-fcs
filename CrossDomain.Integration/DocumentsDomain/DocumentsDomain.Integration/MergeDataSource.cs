namespace SFA.FCT.DocumentsDomain.Integration
{
    using System.Collections.Generic;
    using Aspose.Words.MailMerging;

    public class MergeDataSource : IMailMergeDataSource
    {
        private readonly IList<IDictionary<string, string>> _mergeFields;

        private readonly IDictionary<int, MergeDataSource> _delivarablesDataSources;

        private int _position;

        public MergeDataSource(string tableName)
        {
            _mergeFields = new List<IDictionary<string, string>>();
            _delivarablesDataSources = new Dictionary<int, MergeDataSource>();

            // When the data source is initialized, it must be positioned before the first record.
            _position = -1;
            TableName = tableName;
        }

        public string TableName { get; private set; }

        private bool IsEof
        {
            get { return _position >= _mergeFields.Count; }
        }

        public IMailMergeDataSource GetChildDataSource(string tableName)
        {
            // Needs to be implemented for Nested regions
            if (_delivarablesDataSources.ContainsKey(_position))
            {
                return _delivarablesDataSources[_position];
            }

            return null;
        }

        public bool GetValue(string fieldName, out object fieldValue)
        {
            if (_position >= _mergeFields.Count || _position < 0 || !_mergeFields[_position].ContainsKey(fieldName))
            {
                fieldValue = null;
                return false;
            }

            fieldValue = _mergeFields[_position][fieldName];
            return true;
        }

        public bool MoveNext()
        {
            if (!IsEof)
            {
                _position++;
            }

            return !IsEof;
        }

        public void AddRegionMergeField(int parentRow, string tableName, int row, string name, string value)
        {
            // Check to see if the value is for the top level or one of the sub levels
            if (tableName == TableName)
            {
                TableName = tableName;

                if (row == _mergeFields.Count)
                {
                    _mergeFields.Add(new Dictionary<string, string>());
                }

                _mergeFields[row][name] = value;
            }
            else
            {
                // Check to find a mergeobject in the list of mergeobjects
                MergeDataSource mergeDataStoreToBeUpdated;
                if (_delivarablesDataSources.ContainsKey(parentRow))
                {
                    mergeDataStoreToBeUpdated = _delivarablesDataSources[parentRow];
                }
                else
                {
                    // There is no corresponding merge data source, so add a new one
                    _delivarablesDataSources.Add(parentRow, new MergeDataSource(tableName));
                    mergeDataStoreToBeUpdated = _delivarablesDataSources[parentRow];
                }

                // Now add the row details
                mergeDataStoreToBeUpdated.AddRegionMergeField(parentRow, tableName, row, name, value);
            }
        }
    }
}
