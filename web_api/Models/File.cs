using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using web_api.Cls;

namespace web_api.Models
{
    public class File
    {
        public string FileName { get; set; }

        [JsonConverter(typeof(JsonDateConverter))]
        public DateTime DateModified { get; set; }

        public long Size { get; set; }

    }
}
