#!/usr/bin/env python3

#
# enum_o365tenant is a Microsoft 365 / Entra ID tenant enumeration tool that performs unauthenticated reconnaissance against Microsoft identity endpoints and DNS records.
# For each supplied domain, the script collects tenant metadata from Microsoft tenant discovery APIs and enriches the results.
# Usage: python enum_o365tenant.py domains.txt 
#

import csv
import json
import socket
import sys
import requests
import dns.resolver
import xml.etree.ElementTree as ET

TIMEOUT = 15


def get_json(url):
    try:
        r = requests.get(url, timeout=TIMEOUT)
        return r.json()
    except Exception:
        return {}


def get_text(url):
    try:
        r = requests.get(url, timeout=TIMEOUT)
        return r.text
    except Exception:
        return ""


def get_oidc(domain):
    return get_json(
        f"https://login.microsoftonline.com/{domain}/v2.0/.well-known/openid-configuration"
    )


def get_userrealm(domain):
    return get_json(
        f"https://login.microsoftonline.com/common/userrealm/"
        f"?user=test@{domain}&api-version=2.1"
    )


def get_userrealm_xml(domain):
    xml = get_text(
        f"https://login.microsoftonline.com/GetUserRealm.srf"
        f"?login=test@{domain}&xml=1"
    )

    data = {}

    try:
        root = ET.fromstring(xml)

        for tag in [
            "NameSpaceType",
            "DomainName",
            "FederationBrandName",
            "IsFederatedNS",
            "CloudInstanceName",
            "CloudInstanceIssuerUri",
        ]:
            elem = root.find(tag)
            if elem is not None:
                data[tag] = elem.text

    except Exception:
        pass

    return data


def lookup_mx(domain):
    try:
        records = dns.resolver.resolve(domain, "MX")
        return ";".join(sorted(str(r.exchange).rstrip(".") for r in records))
    except Exception:
        return ""


def lookup_txt(domain):
    try:
        records = dns.resolver.resolve(domain, "TXT")
        vals = []

        for r in records:
            vals.append("".join(x.decode() for x in r.strings))

        return " ; ".join(vals)

    except Exception:
        return ""


def lookup_autodiscover(domain):
    target = f"autodiscover.{domain}"

    try:
        return socket.gethostbyname(target)

    except Exception:
        return ""


def probe_sharepoint(domain):
    tenant = domain.split(".")[0]

    try:
        r = requests.get(
            f"https://{tenant}.sharepoint.com",
            timeout=10,
            allow_redirects=True,
        )

        return str(r.status_code)

    except Exception:
        return ""


def extract_tenant_id(issuer):
    try:
        return issuer.split("/")[3]
    except Exception:
        return ""


def print_record(r):
    print(f"[{r['status']}] {r['domain']}")

    fields = [
        ("TenantID", "tenant_id"),
        ("Brand", "brand"),
        ("Namespace", "namespace"),
        ("RealmDomain", "realm_domain"),
        ("Federated", "is_federated"),
        ("Region", "region"),
        ("Cloud", "cloud"),
        ("Issuer", "issuer"),
        ("Authorization", "authorization_endpoint"),
        ("Token", "token_endpoint"),
        ("JWKS", "jwks_uri"),
        ("MX", "mx"),
        ("TXT", "txt"),
        ("Autodiscover", "autodiscover"),
        ("SharePoint", "sharepoint"),
    ]

    for label, key in fields:
        value = r.get(key)

        if value:
            print(f"  {label:<14}: {value}")

    print()


def main():

    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} domains.txt")
        sys.exit(1)

    results = []

    with open(sys.argv[1], encoding="utf-8") as f:
        domains = [x.strip() for x in f if x.strip()]

    for domain in domains:

        oidc = get_oidc(domain)
        realm = get_userrealm(domain)
        realm_xml = get_userrealm_xml(domain)

        issuer = oidc.get("issuer", "")
        tenant_id = extract_tenant_id(issuer)

        brand = (
            realm.get("FederationBrandName")
            or realm_xml.get("FederationBrandName")
            or ""
        ).strip()

        namespace = (
            realm.get("NameSpaceType")
            or realm_xml.get("NameSpaceType")
            or ""
        )

        record = {
            "status": (
                "M365"
                if issuer
                else (
                    "REALM ONLY"
                    if brand or namespace
                    else "NO TENANT"
                )
            ),
            "domain": domain,
            "tenant_id": tenant_id,
            "brand": brand,
            "namespace": namespace,
            "realm_domain": (
                realm.get("DomainName")
                or realm_xml.get("DomainName")
                or ""
            ),
            "is_federated": realm_xml.get("IsFederatedNS", ""),
            "region": oidc.get("tenant_region_scope", ""),
            "cloud": (
                oidc.get("cloud_instance_name")
                or realm_xml.get("CloudInstanceName", "")
            ),
            "issuer": issuer,
            "authorization_endpoint":
                oidc.get("authorization_endpoint", ""),
            "token_endpoint":
                oidc.get("token_endpoint", ""),
            "jwks_uri":
                oidc.get("jwks_uri", ""),
            "mx":
                lookup_mx(domain),
            "txt":
                lookup_txt(domain),
            "autodiscover":
                lookup_autodiscover(domain),
            "sharepoint":
                probe_sharepoint(domain),
        }

        results.append(record)
        print_record(record)

    outfile = sys.argv[1] + ".csv"

    with open(outfile, "w", newline="", encoding="utf-8") as f:

        writer = csv.DictWriter(
            f,
            fieldnames=[
                "status",
                "domain",
                "tenant_id",
                "brand",
                "namespace",
                "realm_domain",
                "is_federated",
                "region",
                "cloud",
                "issuer",
                "authorization_endpoint",
                "token_endpoint",
                "jwks_uri",
                "mx",
                "txt",
                "autodiscover",
                "sharepoint",
            ],
        )

        writer.writeheader()
        writer.writerows(results)

    print(f"CSV written: {outfile}")


if __name__ == "__main__":
    main()
