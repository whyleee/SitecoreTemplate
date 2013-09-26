using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace SitecoreTemplate.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Message = "Hello, Sitecore!";

            return PartialView();
        }
    }
}
