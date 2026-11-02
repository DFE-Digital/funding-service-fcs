namespace SFA.FCT.CrossDomain.Integration.Common.Repositories
{
    using System;
    using System.Data.Entity;

    public class SettingRepository<T> : ISettingQueryRepository<T>, ISettingCommandRepository where T : class, ISetting, new()
    {
        private readonly IDbSet<T> _settings;
        private readonly Func<int> _saveChanges; 

        public SettingRepository(ISettingContext<T> settingContext)
        {
            _settings = settingContext.Settings;
            _saveChanges = settingContext.SaveChanges;
        }

        public string GetValue(string key)
        {
            return _settings.Find(key)?.Value;
        }

        public void SetValue(string key, string value)
        {
            T setting = _settings.Find(key);

            if (setting != null)
            {
                setting.Value = value;
            }
            else
            {
                setting = new T
                {
                    Key = key,
                    Value = value
                };

                _settings.Add(setting);
            }

            _saveChanges();
        }
    }
}
