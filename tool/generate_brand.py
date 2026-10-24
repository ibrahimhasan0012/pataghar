"""Generate Pataghar's original geometric mark for every install surface.
Requires Pillow; coordinates match the Android adaptive foreground vector.
"""
from pathlib import Path
from PIL import Image, ImageDraw
import json
ROOT = Path(__file__).resolve().parents[1]
GREEN = '#175440'
CREAM = '#FFFCF0'
RUST = '#E4A06E'

def icon(size):
    im = Image.new('RGB', (1080, 1080), GREEN)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle((320, 310, 800, 800), radius=35, fill='#8DB7A2')
    d.rounded_rectangle((270, 250, 740, 750), radius=30, fill=CREAM)
    d.rectangle((330, 320, 440, 430), fill=RUST)
    d.rectangle((480, 320, 680, 350), fill=GREEN)
    d.rectangle((480, 395, 680, 425), fill=GREEN)
    for y in (490, 565, 640):
        d.rectangle((330, y, 480, y+25), fill=GREEN)
        d.rectangle((525, y, 680, y+25), fill=GREEN)
    return im.resize((size,size), Image.Resampling.LANCZOS)

brand = ROOT / 'assets/brand'; brand.mkdir(exist_ok=True)
icon(1024).save(brand / 'pataghar.png')
res = ROOT / 'android/app/src/main/res'
for density,size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    folder=res/('mipmap-'+density);folder.mkdir(exist_ok=True)
    icon(size).save(folder/'ic_launcher.png')
    icon(size).save(folder/'ic_launcher_round.png')
foreground='''<vector xmlns:android="http://schemas.android.com/apk/res/android" android:width="108dp" android:height="108dp" android:viewportWidth="108" android:viewportHeight="108">
<path android:fillColor="#8DB7A2" android:pathData="M35,31H77Q80,31 80,34V77Q80,80 77,80H35Q32,80 32,77V34Q32,31 35,31Z"/>
<path android:fillColor="#FFFCF0" android:pathData="M30,25H71Q74,25 74,28V72Q74,75 71,75H30Q27,75 27,72V28Q27,25 30,25Z"/>
<path android:fillColor="#E4A06E" android:pathData="M33,32H44V43H33Z"/>
<path android:fillColor="#175440" android:pathData="M48,32H68V35H48ZM48,39.5H68V42.5H48ZM33,49H48V51.5H33ZM52.5,49H68V51.5H52.5ZM33,56.5H48V59H33ZM52.5,56.5H68V59H52.5ZM33,64H48V66.5H33ZM52.5,64H68V66.5H52.5Z"/>
</vector>'''
(res/'drawable/ic_pataghar_foreground.xml').write_text(foreground)
(res/'drawable/ic_pataghar_monochrome.xml').write_text('''<vector xmlns:android="http://schemas.android.com/apk/res/android" android:width="108dp" android:height="108dp" android:viewportWidth="108" android:viewportHeight="108"><path android:fillColor="#FFFFFF" android:fillType="evenOdd" android:pathData="M27,25H74V75H27ZM33,32V43H44V32ZM48,32V35H68V32ZM48,39.5V42.5H68V39.5ZM33,49V51.5H48V49ZM52.5,49V51.5H68V49ZM33,56.5V59H48V56.5ZM52.5,56.5V59H68V56.5ZM33,64V66.5H48V64ZM52.5,64V66.5H68V64ZM77,31H80V80H32V78H77Z"/></vector>''')
for api,mono in [('26',''),('33','    <monochrome android:drawable="@drawable/ic_pataghar_monochrome"/>\n')]:
    folder=res/('mipmap-anydpi-v'+api);folder.mkdir(exist_ok=True)
    xml='''<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/pataghar_green"/>
    <foreground android:drawable="@drawable/ic_pataghar_foreground"/>
'''+mono+'</adaptive-icon>\n'
    for name in ['ic_launcher','ic_launcher_round']:(folder/(name+'.xml')).write_text(xml)
(res/'values/pataghar_colors.xml').write_text('<resources><color name="pataghar_green">#175440</color></resources>\n')
ios=ROOT/'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for entry in json.loads((ios/'Contents.json').read_text())['images']:
    size=round(float(entry['size'].split('x')[0])*float(entry['scale'].rstrip('x')))
    icon(size).save(ios/entry['filename'])
for name,size in [('Icon-192',192),('Icon-512',512),('Icon-maskable-192',192),('Icon-maskable-512',512)]:
    icon(size).save(ROOT/('web/icons/'+name+'.png'))
icon(32).save(ROOT/'web/favicon.png')
launch=ROOT/'ios/Runner/Assets.xcassets/LaunchImage.imageset'
for scale in (1,2,3):
    icon(160*scale).save(launch/('LaunchImage'+('' if scale==1 else '@'+str(scale)+'x')+'.png'))
print('Generated Android adaptive/themed/legacy, iPhone/iPad and web icons.')
