# IceBreakerCard

**IceBreakerCard** เป็นแอป Flutter สำหรับสุ่มคำถามลายพฤติกรรม เพื่อเริ่มการสนทนา ทำความรู้จักกันมากขึ้น เหมาะสำหรับเล่นกับเพื่อนหรือคนที่อยากรู้จัก กิจกรรมกลุ่ม

แอปมีฟีเจอร์:  
- เลือกหมวดคำถาม: ทั่วไป, ผ่อนคลาย, การงาน/เรียน, ทัศนคติ/ความคิด  
- สุ่มคำถามเพื่อใช้ในชวนคุย
- เพิ่ม/ลบ/แก้ไข คำถามได้
- บันทึกคำถามโปรดและแชร์ไปยังแอปอื่น  


# 1. โคลนโปรเจกต์

<pre><code>gh repo clone lemmegotobed/IceBreakerCard</code></pre>
<pre><code>cd IceBreakerCard</code></pre>

# 2. ติดตั้ง Dependencies

<pre><code>flutter pub get</code></pre>

# 3. ติดตั้ง PocketBase  

ถ้าไม่มี PocketBase ให้ดาวน์โหลดได้จาก https://pocketbase.io/docs/

<pre><code>/pocketbase serve</code></pre>

จากนั้นเข้าเข้าสู่ระบบ http://127.0.0.1:8090/_/ สร้างฐานข้อมูลและCollection ตั้งชื่อ questions

# 4. สร้างข้อมูลจำลองด้วย Faker

<pre><code>node tools/seed_faker.mjs </code></pre>

# 3. รันแอป

<pre><code>flutter run -d chrome</code></pre>
