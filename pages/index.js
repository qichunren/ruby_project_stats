import Head from 'next/head'
import {useTranslation, useLanguageQuery, LanguageSwitcher} from "next-export-i18n"

import LinkItem from "../components/home/link_item"

const sites = [
  {name: "Ruby lang", url: "http://ddddd"},
  {name: "mruby", url: "http://ddddd3 3"},
  {name: "Ruby On Rails", url: "http://ddddd 32"},
  {name: "Hotwire", url: "http://ddddd 23"},
  {name: "Ruby weekly", url: "http://ddddd 23"},
  {name: "Ruby Radar", url: "http://ddddd 23"},
  {name: "GoRails", url: "http://ddddd 23"},
]

export default function Home() {
  const { t } = useTranslation();
  const [query] = useLanguageQuery();
  
  return (
    <>    
      <Head>
        <title>Ruby project stats</title>
        <meta name="description" content="" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <section id="hero" className="my-2 container mx-auto text-black grid grid-cols-4 grid-flow-row gap-4">
        {sites.map((s) => 
          <LinkItem site={s} />     
          )
        }       
      </section>
      
    </>
  )
}
