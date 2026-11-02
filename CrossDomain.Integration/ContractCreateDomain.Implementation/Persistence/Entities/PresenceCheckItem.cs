namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    using System;
    using System.Collections.Generic;

    public class PresenceCheckItem
    {
        private bool _isPresent;

        public PresenceCheckItem(string entityName, List<ColumnValue> columnValues)
        {
            EntityName = entityName;
            ColumnValues = columnValues;
            ColumnValuesOneOfThese = new List<ColumnValue>();
        }

        public string EntityName { get; set; }

        /// <summary>
        /// Gets or sets the column values used for the where clause, each of these items must be present
        /// </summary>
        public List<ColumnValue> ColumnValues { get; set; }

        /// <summary>
        /// Gets or sets the column values used for the where clause, one of these items must be present
        /// </summary>
        public List<ColumnValue> ColumnValuesOneOfThese { get; set; }

        public bool IsPresent
        {
            get 
            { 
                return _isPresent; 
            }

            set
            {
                _isPresent = value;
                if (SetPresent != null)
                {
                    SetPresent(value);
                }
            }
        }

        public object OriginalObject { get; set; }

        public Action<bool> SetPresent { get; set; }
    }
}