using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace web_api.Cls
{
    public class JsonDateConverter : IsoDateTimeConverter
    {
        public JsonDateConverter()
        {
            DateTimeFormat = "yyyy-MM-ddTHH:mm:ss";
        }
    }
}
