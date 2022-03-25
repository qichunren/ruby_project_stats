import {useTranslation, useLanguageQuery, LanguageSwitcher} from "next-export-i18n"

function Footer({site}) {
	const { t } = useTranslation();
    const [query] = useLanguageQuery();

	return (
		<div className="flex items-center gap-4 border rounded">
			<img src="/header-ruby-logo.png" />
            <div className="flex flex-col">
                <h4 className="font-bold">{site.name}</h4>
                <p>{site.url}</p>
            </div>
		</div>
	)
}

export default Footer;
