import string


def clean_text(text):
    # Remove web links
    text = " ".join([i for i in text.split() if "http" not in i])

    # Replace punctuations with spaces
    for punctuation in string.punctuation:
        text = text.replace(punctuation, " ")

    # Replace repeated spaces with single space
    text = " ".join(text.strip().lower().split())
    return text


if __name__ == "__main__":
    text = "	Intravenous azithromycin-induced ototoxicity.()lolcrc http://dwefsade.com"
    print(clean_text(text))