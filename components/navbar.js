import Link from "next/link";
import {useTranslation, useLanguageQuery, LanguageSwitcher} from "next-export-i18n"

import { BiGlobe } from "react-icons/bi";

function Navbar() {
  const { t } = useTranslation();
  const [query] = useLanguageQuery();

    return (
        <div className="bg-black">
            <div className="container mx-auto flex flex-col sm:flex-row gap-2 sm:gap-0 items-stretch sm:justify-between px-2 py-2 sm:py-6">
                <div className="flex justify-between items-center gap-4">
                    <Link href={{pathname:`/index.html`, query: query}}>
                        <a className="flex items-center gap-4 text-2xl text-red-500">                            
                            ruby_project_stats
                        </a>
                    </Link>
                    
                    <nav className="langSwitcher ml-4 flex items-center gap-2 text-white">
                        <BiGlobe />
                        <LanguageSwitcher lang="cn">Chinese</LanguageSwitcher> |{' '}
                        <LanguageSwitcher lang="en">English</LanguageSwitcher>
                    </nav>
                    
                </div>
                
                <div className="flex justify-between items-center">
                    <Link href={{pathname:`/ruby_lang.html`, query: query}} ><a className="px-1 sm:px-2 md:px-4 lg:px-6 py-2 text-sm font-bold text-red-400 hover:bg-red-400 hover:text-black hover:rounded-lg">{t("nav.ruby_lang")}</a>
                    </Link>
                    <Link href={{pathname:`/rails_front.html`, query: query}} ><a className="px-2 sm:px-4 md:px-4 lg:px-6 py-2 text-sm font-bold text-red-400 hover:bg-red-400 hover:text-black hover:rounded-lg">{t("nav.frontend")}</a>
                    </Link>
                    <Link href={{pathname:`/rails_lib.html`, query: query}} ><a className="px-1 sm:px-2 md:px-4 lg:px-6 py-2 text-sm font-bold text-red-400 hover:bg-red-400 hover:text-black hover:rounded-lg">{t("nav.library")}</a>
                    </Link>
                    <Link href={{pathname:`/rails_app.html`, query: query}} ><a className="px-1 sm:px-2 md:px-4 lg:px-6 py-2 text-sm font-bold text-red-400 hover:bg-red-400 hover:text-black hover:rounded-lg">{t("nav.application")}</a>
                    </Link>                    
                </div>
            </div>
        </div>        
    )
}

export default Navbar;
