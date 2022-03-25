import {useTranslation, useLanguageQuery, LanguageSwitcher} from "next-export-i18n"

function Footer() {
	const { t } = useTranslation();
    const [query] = useLanguageQuery();

	return (
		<footer className="bg-red-400 text-black">
			<div className="container mx-auto flex flex-col items-center gap-4 py-6">				
				<div>Version: 0.1.0</div>
			</div>
		</footer>
	)
}

export default Footer;
